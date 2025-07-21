
import subprocess
import base64
import logging
import sys
import os

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def convert_audio_to_pcm16(raw_bytes: bytes) -> bytes:
    """
    Convert WebM audio to PCM16 format using FFmpeg
    """
    if len(raw_bytes) == 0:
        logger.warning("Empty audio input")
        return b""
    
    logger.info(f"Converting audio: {len(raw_bytes)} bytes input")
    
    try:
        process = subprocess.Popen(
            [
                "ffmpeg",
                "-f", "webm",
                "-i", "pipe:0",
                "-f", "s16le",
                "-acodec", "pcm_s16le",
                "-ac", "1",  # mono
                "-ar", "24000",  # 24kHz sample rate
                "-y",  # overwrite output
                "-loglevel", "warning",  # reduce log verbosity
                "pipe:1"
            ],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        
        pcm_output, err = process.communicate(input=raw_bytes, timeout=10)
        
        if process.returncode != 0:
            logger.error(f"FFmpeg error (code {process.returncode}): {err.decode()}")
            return b""
        
        if err:
            logger.debug(f"FFmpeg stderr: {err.decode()}")
            
        # Calculate duration (PCM16 at 24kHz, mono)
        duration_ms = (len(pcm_output) / 2) / 24000 * 1000
        logger.info(f"Audio converted: {len(pcm_output)} bytes output, {duration_ms:.2f}ms duration")
        
        return pcm_output
        
    except subprocess.TimeoutExpired:
        logger.error("FFmpeg conversion timeout")
        process.kill()
        return b""
    except Exception as e:
        logger.error(f"Audio conversion error: {e}")
        return b""

def test_conversion():
    """Test audio conversion with a sample WebM file"""
    
    # Check if ffmpeg is available
    try:
        result = subprocess.run(["ffmpeg", "-version"], 
                              capture_output=True, text=True, timeout=5)
        if result.returncode != 0:
            logger.error("FFmpeg not found or not working")
            return False
    except Exception as e:
        logger.error(f"FFmpeg check failed: {e}")
        return False
    
    logger.info("FFmpeg is available")
    
    # Create a simple test audio file
    try:
        # Generate a 1-second sine wave test audio in WebM format
        process = subprocess.Popen([
            "ffmpeg",
            "-f", "lavfi",
            "-i", "sine=frequency=440:duration=1:sample_rate=48000",
            "-f", "webm",
            "-acodec", "libopus",
            "-ac", "1",
            "-y",
            "pipe:1"
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        
        test_webm, err = process.communicate(timeout=10)
        
        if process.returncode != 0:
            logger.error(f"Test audio generation failed: {err.decode()}")
            return False
            
        logger.info(f"Generated test WebM audio: {len(test_webm)} bytes")
        
        # Test conversion
        pcm_data = convert_audio_to_pcm16(test_webm)
        
        if len(pcm_data) == 0:
            logger.error("Conversion failed - no output")
            return False
            
        # Validate the output
        expected_samples = 24000  # 1 second at 24kHz
        actual_samples = len(pcm_data) // 2  # 16-bit samples
        
        logger.info(f"Expected samples: {expected_samples}, Actual samples: {actual_samples}")
        
        if abs(actual_samples - expected_samples) > 100:  # Allow some tolerance
            logger.warning(f"Sample count mismatch: expected ~{expected_samples}, got {actual_samples}")
        
        # Test with OpenAI format
        audio64 = base64.b64encode(pcm_data).decode()
        logger.info(f"Base64 encoded length: {len(audio64)}")
        
        logger.info("✅ Audio conversion test passed!")
        return True
        
    except Exception as e:
        logger.error(f"Test failed: {e}")
        return False

def test_minimum_duration():
    """Test audio chunks with different durations"""
    
    durations = [0.1, 0.5, 1.0, 2.0]  # seconds
    
    for duration in durations:
        logger.info(f"Testing {duration}s audio...")
        
        try:
            # Generate test audio
            process = subprocess.Popen([
                "ffmpeg",
                "-f", "lavfi",
                "-i", f"sine=frequency=440:duration={duration}:sample_rate=48000",
                "-f", "webm",
                "-acodec", "libopus",
                "-ac", "1",
                "-y",
                "pipe:1"
            ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            
            test_webm, err = process.communicate(timeout=10)
            
            if process.returncode != 0:
                logger.error(f"Failed to generate {duration}s audio: {err.decode()}")
                continue
                
            # Convert
            pcm_data = convert_audio_to_pcm16(test_webm)
            
            if len(pcm_data) > 0:
                duration_ms = (len(pcm_data) / 2) / 24000 * 1000
                logger.info(f"✅ {duration}s -> {duration_ms:.2f}ms PCM")
                
                # Check if it meets OpenAI's 100ms minimum
                if duration_ms >= 100:
                    logger.info(f"  ✅ Meets OpenAI 100ms minimum requirement")
                else:
                    logger.warning(f"  ⚠️  Below OpenAI 100ms minimum requirement")
            else:
                logger.error(f"❌ Conversion failed for {duration}s audio")
                
        except Exception as e:
            logger.error(f"Error testing {duration}s audio: {e}")

if __name__ == "__main__":
    print("🎵 Audio Conversion Test Script")
    print("=" * 40)
    
    if test_conversion():
        print("\n🔄 Testing different audio durations...")
        test_minimum_duration()
    else:
        print("❌ Basic conversion test failed")
        sys.exit(1)
    
    print("\n✅ All tests completed!")