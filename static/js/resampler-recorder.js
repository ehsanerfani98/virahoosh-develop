// نسخه ساده‌شده‌ی Recorder + Resampler
class ResamplerRecorder {
  constructor(sourceNode, options = {}) {
    this.context = sourceNode.context;
    this.source = sourceNode;
    this.bufferSize = options.bufferSize || 4096;
    this.inputSampleRate = this.context.sampleRate;
    this.targetSampleRate = options.targetSampleRate || 24000;
    this.numChannels = options.numChannels || 1;

    this.processor = this.context.createScriptProcessor(this.bufferSize, this.numChannels, this.numChannels);
    this.audioBuffer = [];
    this.recording = false;

    this.processor.onaudioprocess = (e) => {
      if (!this.recording) return;
      const inputData = e.inputBuffer.getChannelData(0);
      this.audioBuffer.push(new Float32Array(inputData));
    };
    sourceNode.connect(this.processor);
    this.processor.connect(this.context.destination);
  }

  start() {
    this.audioBuffer = [];
    this.recording = true;
  }

  stop() {
    this.recording = false;
  }

  async exportPCM16() {
    // concatenate
    const totalLen = this.audioBuffer.reduce((sum, b) => sum + b.length, 0);
    const buffer = new Float32Array(totalLen);
    let offset = 0;
    for (const b of this.audioBuffer) {
      buffer.set(b, offset);
      offset += b.length;
    }
    // resample
    const offline = new OfflineAudioContext(1, buffer.length * this.targetSampleRate / this.inputSampleRate, this.targetSampleRate);
    const tmpSrc = offline.createBufferSource();
    const wavBuf = offline.createBuffer(1, buffer.length, this.inputSampleRate);
    wavBuf.copyToChannel(buffer, 0);
    tmpSrc.buffer = wavBuf;
    tmpSrc.connect(offline.destination);
    tmpSrc.start();
    const rendered = await offline.startRendering();

    // convert Float32 -> Int16
    const resampled = rendered.getChannelData(0);
    const pcm16 = new Int16Array(resampled.length);
    for (let i = 0; i < resampled.length; i++) {
      const s = Math.max(-1, Math.min(1, resampled[i]));
      pcm16[i] = s < 0 ? s * 0x8000 : s * 0x7FFF;
    }
    return pcm16.buffer;
  }
}
