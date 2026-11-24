import 'package:flutter/material.dart';
import '../../core/constants/app_enums.dart';

abstract class IVoiceService {
  Future<bool> initialize();
  Future<bool> checkPermission();
  Future<void> startListening({required Function(String text) onResult});
  Future<void> stopListening();
  Future<void> speak(String text, {VoidCallback? onComplete});
  Future<void> stopSpeaking();
  void setMuted(bool isMuted);
  bool get isMuted;
  bool get isListening;
  bool get isSpeaking;
}

/// Simulated voice service providing speech interaction without native binary dependencies
class JarvisVoiceService implements IVoiceService {
  bool _isMuted = false;
  bool _isListening = false;
  bool _isSpeaking = false;

  @override
  bool get isMuted => _isMuted;

  @override
  bool get isListening => _isListening;

  @override
  bool get isSpeaking => _isSpeaking;

  @override
  Future<bool> initialize() async {
    return true;
  }

  @override
  Future<bool> checkPermission() async {
    return true;
  }

  @override
  Future<void> startListening({required Function(String text) onResult}) async {
    _isListening = true;
    // Simulate speech-to-text input after listening delay
    await Future.delayed(const Duration(seconds: 3));
    if (_isListening) {
      _isListening = false;
      onResult("JARVIS, give me a status update on current systems.");
    }
  }

  @override
  Future<void> stopListening() async {
    _isListening = false;
  }

  @override
  Future<void> speak(String text, {VoidCallback? onComplete}) async {
    if (_isMuted) return;
    _isSpeaking = true;
    final speechDuration = Duration(
      milliseconds: (text.length * 50).clamp(1200, 4500),
    );
    await Future.delayed(speechDuration);
    _isSpeaking = false;
    onComplete?.call();
  }

  @override
  Future<void> stopSpeaking() async {
    _isSpeaking = false;
  }

  @override
  void setMuted(bool isMuted) {
    _isMuted = isMuted;
    if (_isMuted && _isSpeaking) {
      stopSpeaking();
    }
  }
}
