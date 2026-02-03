import torch
from transformers import pipeline
import soundfile as sf
import numpy as np
import os

class SpeechService:
    def __init__(self):
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        print(f"[SpeechService] Using device: {self.device}")

        self._stt_pipe = None
        self._tts_pipe = None

    def _load_stt(self):
        if self._stt_pipe is None:
            print("[SpeechService] Loading Whisper STT model...")
            self._stt_pipe = pipeline(
                "automatic-speech-recognition",
                model="openai/whisper-tiny",
                device=self.device
            )
        return self._stt_pipe

    def _load_tts(self):
        if self._tts_pipe is None:
            print("[SpeechService] Loading MMS-TTS model...")
            self._tts_pipe = pipeline(
                "text-to-speech",
                model="facebook/mms-tts-eng",
                device=self.device
            )
        return self._tts_pipe

    def transcribe(self, audio_path: str) -> str:
        audio, sr = sf.read(audio_path)
        if len(audio.shape) > 1:
            audio = audio.mean(axis=1)

        if np.abs(audio).max() < 0.01:
            return ""

        stt = self._load_stt()
        result = stt(
            audio,
            generate_kwargs={"language": "english", "task": "transcribe"}
        )
        return result["text"].strip()

    def synthesize(self, text: str, output_path: str):
        if not text or len(text.strip()) < 2:
            text = "I'm sorry, I didn't catch that. Could you please repeat?"

        try:
            tts = self._load_tts()
            output = tts(text)
            audio_data = output["audio"][0]
            sampling_rate = output["sampling_rate"]
            sf.write(output_path, audio_data, sampling_rate)
            return output_path
        except Exception as e:
            print(f"TTS Error: {e}")
            sf.write(output_path, np.zeros(16000), 16000)
            return output_path
