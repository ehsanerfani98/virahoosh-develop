# services/openai_service.py

from openai import OpenAI, AsyncOpenAI
from core.config import OPENAI_API_KEY, DEEPSEEK_API_KEY
from PIL import Image
from io import BytesIO
import asyncio, base64
from fastapi import WebSocket, WebSocketDisconnect
import logging
from fastapi.websockets import WebSocketState
import time
import io
import wave

# Configure detailed logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class AudioSession:
    """Track audio session state"""
    def __init__(self):
        self.audio_buffer_has_data = False
        self.total_audio_sent = 0
        self.total_audio_received = 0
        self.session_start = time.time()
        self.last_audio_time = None
        self.openai_connected = False
        self.websocket_connected = False

    def log_stats(self):
        duration = time.time() - self.session_start
        logger.info(f"Session stats: {duration:.1f}s, sent: {self.total_audio_sent} bytes, received: {self.total_audio_received} bytes")
        
        
clientb = AsyncOpenAI(api_key=OPENAI_API_KEY)

client = OpenAI(api_key=OPENAI_API_KEY)


def run_openai_prompt(prompt_text: str, system_prompt: str, max_tokens: int, model: str, provider: str) -> str:
    try:
        if provider == "openai":
            response = client.chat.completions.create(
                model=model,
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": prompt_text}
                ],
                temperature=0.5,
                max_tokens=max_tokens
            )
            return response.choices[0].message.content.strip()

        elif provider == "deepseek":
            # نمونه ساختگی: اگر DeepSeek API متفاوت است، جایگزین کن
            # این فقط نمونه است و باید DeepSeek SDK واقعی یا API client داشته باشی
            import requests
            deepseek_url = "https://api.deepseek.com/chat/completions"
            headers = {"Authorization": f"Bearer {DEEPSEEK_API_KEY}"}
            payload = {
                "model": model,
                "messages": [
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": prompt_text}
                ],
            }
            r = requests.post(deepseek_url, json=payload, headers=headers)
            r.raise_for_status()
            return r.json()["choices"][0]["message"]["content"].strip()

        else:
            return "سرویس ناشناخته انتخاب شده است."

    except Exception as e:
        return f"خطا در پاسخ‌دهی: {e}"


def generate_image_by_prompt(prompt: str, size: str = "1792x1024") -> str:
    try:
        response = client.images.generate(
            model="dall-e-3",
            prompt=prompt,
            n=1,
            size=size,
            response_format="url"
        )
        return response.data[0].url
    except Exception as e:
        return None


def translate_to_english(text: str, model: str, provider: str) -> str:
    try:
        if provider == "openai":
            response = client.chat.completions.create(
                model=model,
                messages=[
                    {"role": "system", "content": "You are an English translator.Just translate, do not add any extra explanation."},
                    {"role": "user", "content": f"Translate the text '{text}' into English."}
                ],
                temperature=0,
            )
            return response.choices[0].message.content.strip()

        elif provider == "deepseek":
            # نمونه ساختگی مشابه قبل، جایگزین با API واقعی DeepSeek
            import requests
            deepseek_url = "https://api.deepseek.com/chat/completions"
            headers = {"Authorization": f"Bearer {DEEPSEEK_API_KEY}"}
            payload = {
                "model": model,
                "messages": [
                    {"role": "system", "content": "You are an English translator."},
                    {"role": "user", "content": f"Translate the text '{text}' into English.Just translate, do not add any extra explanation."}
                ],
            }
            r = requests.post(deepseek_url, json=payload, headers=headers)
            r.raise_for_status()
            return r.json()["choices"][0]["message"]["content"].strip()

        else:
            return "سرویس ناشناخته انتخاب شده است."

    except Exception as e:
        return f"خطا در پاسخ‌دهی: {e}"


def text_to_speech(
    input_text: str,
    model: str,
    voice: str,
    output_path: str,
    format: str,
    instructions: str = "با لحنی عصبانی و خشن صحبت کن"
) -> str:
    try:
        response = client.audio.speech.create(
            model=model,
            input=input_text,
            voice=voice,
            response_format=format,
            instructions=instructions,
        )
        # ذخیره صدا در فایل (با استفاده از response.content)
        with open(output_path, "wb") as f:
            f.write(response.content)
        return output_path

    except Exception as e:
        return f"خطا در تولید صدا: {e}"


def analyze_image_with_openai_vision(image: Image.Image, max_tokens: int, prompt: str, model: str = "gpt-4-vision-preview") -> str:
    try:
        buffered = BytesIO()
        image.save(buffered, format="PNG")
        img_str = base64.b64encode(buffered.getvalue()).decode()

        response = client.chat.completions.create(
            model=model,
            messages=[
                {
                    "role": "user",
                    "content": [
                        {"type": "text", "text": prompt},
                        {"type": "image_url", "image_url": {
                            "url": f"data:image/png;base64,{img_str}"
                        }}
                    ]
                }
            ],
            max_completion_tokens=max_tokens
        )
        return response.choices[0].message.content.strip()

    except Exception as e:
        return f"خطا در تحلیل تصویر: {e}"




async def realtime_audio_relay(websocket: WebSocket, deployment: str):
    session = AudioSession()
    session.websocket_connected = True

    try:
        logger.info(f"Connecting to OpenAI realtime API with model: {deployment}")

        async with clientb.beta.realtime.connect(model=deployment) as conn:
            session.openai_connected = True
            logger.info("✅ Connected to OpenAI realtime API")

            session_config = {
                "modalities": ["text", "audio"],
                "instructions": "You are a helpful assistant. Respond naturally and conversationally.",
                "voice": "alloy",
                "input_audio_format": "pcm16",
                "output_audio_format": "pcm16",
                "input_audio_transcription": {
                    "model": "whisper-1"
                },
                "turn_detection": {
                    "type": "server_vad",
                    "threshold": 0.5,
                    "prefix_padding_ms": 300,
                    "silence_duration_ms": 500
                },
                "tool_choice": "auto",
                "temperature": 0.8,
                "max_response_output_tokens": 4096
            }

            logger.info("Updating session configuration...")
            await conn.session.update(session=session_config)
            logger.info("✅ Session configuration updated")

            async def send_to_openai():
                logger.info("🎤 Audio receiver task started")

                while session.websocket_connected:
                    try:
                        msg = await websocket.receive_bytes()
                        session.last_audio_time = time.time()
                        session.total_audio_received += len(msg)
                        logger.info(f"📥 Received audio: {len(msg)} bytes (total: {session.total_audio_received})")

                        # بررسی حداقل طول داده
                        if len(msg) < 480:  # کمتر از 20ms در 24kHz*2byte
                            logger.warning("⚠️ Audio chunk too short - skipping")
                            continue

                        audio64 = base64.b64encode(msg).decode()
                        await conn.send({"type": "input_audio_buffer.append", "audio": audio64})

                        session.audio_buffer_has_data = True
                        session.total_audio_sent += len(msg)
                        logger.info(f"✅ Audio sent to OpenAI (total sent: {session.total_audio_sent} bytes)")

                    except WebSocketDisconnect:
                        logger.info("🔌 Client disconnected")
                        session.websocket_connected = False
                        break
                    except Exception as e:
                        logger.error(f"❌ Error in audio receiver: {e}")
                        break

                if session.audio_buffer_has_data:
                    logger.info("💾 Committing audio buffer to OpenAI...")
                    try:
                        await conn.send({"type": "input_audio_buffer.commit"})
                        logger.info("✅ Audio buffer committed successfully")
                    except Exception as e:
                        logger.error(f"❌ Error committing audio buffer: {e}")
                else:
                    logger.info("ℹ️ No audio data to commit")

                logger.info("🏁 Audio sender task finished")

            async def recv_from_openai():
                logger.info("🎧 OpenAI receiver task started")

                async for ev in conn:
                    if not session.websocket_connected:
                        logger.info("🔌 WebSocket disconnected, stopping OpenAI receiver")
                        break
                    if websocket.client_state == WebSocketState.DISCONNECTED:
                        logger.info("🔌 WebSocket client disconnected, stopping OpenAI receiver")
                        break

                    try:
                        logger.debug(f"📨 Received OpenAI event: {ev.type}")

                        if ev.type == 'error':
                            logger.error(f"❌ OpenAI error: {ev.error}")
                            await websocket.send_json({"type": "error", "error": str(ev.error)})

                        elif ev.type == "response.audio.delta":
                            if hasattr(ev, 'delta') and ev.delta:
                                audio_data = base64.b64decode(ev.delta)
                                await websocket.send_bytes(audio_data)

                        elif ev.type == "response.audio.done":
                            await websocket.send_json({"type": "audio_done"})

                        elif ev.type == "input_audio_buffer.speech_started":
                            await websocket.send_json({"type": "status", "status": "listening"})

                        elif ev.type == "input_audio_buffer.speech_stopped":
                            await websocket.send_json({"type": "status", "status": "processing"})

                        elif ev.type == "conversation.item.input_audio_transcription.completed":
                            transcript = getattr(ev, "transcript", "")
                            if transcript:
                                await websocket.send_json({"type": "transcript", "transcript": transcript})

                        elif ev.type == "response.text.delta":
                            if hasattr(ev, 'delta') and ev.delta:
                                await websocket.send_json({"type": "text", "text": ev.delta})

                        elif ev.type == "session.created":
                            await websocket.send_json({"type": "session_ready", "message": "Ready to receive audio"})

                        elif ev.type == "session.updated":
                            pass

                    except Exception as e:
                        if session.websocket_connected:
                            logger.error(f"❌ Error processing OpenAI event: {e}")
                        break

                logger.info("🏁 OpenAI receiver task finished")

            logger.info("🚀 Starting audio relay tasks...")
            await asyncio.gather(send_to_openai(), recv_from_openai())

    except Exception as e:
        logger.error(f"❌ Fatal error in realtime_audio_relay: {e}")
        if session.websocket_connected:
            try:
                await websocket.send_json({"type": "error", "error": "Server connection error"})
            except: pass
    finally:
        session.websocket_connected = False
        session.openai_connected = False
        session.log_stats()
        logger.info("🏁 Audio relay finished")


def convert_audio_to_pcm16_detailed(raw_bytes: bytes) -> bytes:
    try:
        with wave.open(io.BytesIO(raw_bytes), 'rb') as wav_file:
            n_channels = wav_file.getnchannels()
            sampwidth = wav_file.getsampwidth()
            framerate = wav_file.getframerate()
            n_frames = wav_file.getnframes()
            pcm_data = wav_file.readframes(n_frames)

            logger.info(f"WAV Info: {n_channels}ch, {sampwidth*8}-bit, {framerate}Hz, {n_frames} frames")

            if sampwidth != 2:
                logger.warning(f"⚠️ Unexpected sample width: {sampwidth*8} bits (expected 16-bit)")
            if n_channels != 1:
                logger.warning(f"⚠️ Unexpected number of channels: {n_channels} (expected mono)")
            if framerate != 24000:
                logger.warning(f"⚠️ Unexpected sample rate: {framerate} Hz (expected 24000 Hz)")

            return pcm_data
    except Exception as e:
        logger.error(f"❌ Error decoding WAV/PCM audio: {e}")
        return b''
