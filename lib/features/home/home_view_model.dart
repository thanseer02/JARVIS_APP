import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_enums.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/conversation_model.dart';
import '../../data/repositories/jarvis_repository_interface.dart';
import '../../data/services/jarvis_api_client.dart';
import '../voice/voice_service.dart';

class JarvisMainViewModel extends ChangeNotifier {
  final IJarvisRepository _repository;
  final IVoiceService _voiceService;
  final JarvisApiClient _apiClient;

  OrbState _orbState = OrbState.idle;
  BackendConnectionStatus _connectionStatus = BackendConnectionStatus.mockMode;
  List<ConversationModel> _recentConversations = [];
  ConversationModel? _activeConversation;
  bool _isLoading = false;
  String? _errorMessage;

  JarvisMainViewModel({
    required IJarvisRepository repository,
    required IVoiceService voiceService,
    required JarvisApiClient apiClient,
  })  : _repository = repository,
        _voiceService = voiceService,
        _apiClient = apiClient {
    init();
  }

  // Getters
  OrbState get orbState => _orbState;
  BackendConnectionStatus get connectionStatus => _connectionStatus;
  List<ConversationModel> get recentConversations => _recentConversations;
  ConversationModel? get activeConversation => _activeConversation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isVoiceMuted => _voiceService.isMuted;
  bool get isVoiceListening => _voiceService.isListening;
  bool get isVoiceSpeaking => _voiceService.isSpeaking;
  JarvisApiClient get apiClient => _apiClient;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await refreshConnectionStatus();
    await loadRecentConversations();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshConnectionStatus() async {
    if (_apiClient.config.useMock) {
      _connectionStatus = BackendConnectionStatus.mockMode;
    } else {
      _connectionStatus = BackendConnectionStatus.connecting;
      notifyListeners();
      final isHealthy = await _repository.checkBackendHealth();
      _connectionStatus = isHealthy
          ? BackendConnectionStatus.connected
          : BackendConnectionStatus.disconnected;
    }
    notifyListeners();
  }

  Future<void> loadRecentConversations() async {
    try {
      _recentConversations = await _repository.getConversations();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void setOrbState(OrbState state) {
    _orbState = state;
    notifyListeners();
  }

  Future<ConversationModel> startNewConversation({String? title}) async {
    _setLoading(true);
    final conv = await _repository.createConversation(initialTitle: title);
    _activeConversation = conv;
    await loadRecentConversations();
    _setLoading(false);
    return conv;
  }

  Future<void> selectConversation(String id) async {
    _setLoading(true);
    _activeConversation = await _repository.getConversationById(id);
    _setLoading(false);
  }

  Future<void> deleteConversation(String id) async {
    await _repository.deleteConversation(id);
    if (_activeConversation?.id == id) {
      _activeConversation = null;
    }
    await loadRecentConversations();
  }

  Future<void> sendChatMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Ensure we have an active conversation
    if (_activeConversation == null) {
      await startNewConversation();
    }

    final convId = _activeConversation!.id;
    final userMsg = ChatMessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: convId,
      text: text.trim(),
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      isPending: true,
    );

    // Optimistically update conversation
    _activeConversation = _activeConversation!.copyWith(
      messages: [..._activeConversation!.messages, userMsg],
      lastMessagePreview: text.trim(),
      updatedAt: DateTime.now(),
    );
    _orbState = OrbState.thinking;
    notifyListeners();

    try {
      final assistantReply = await _repository.sendMessage(
        conversationId: convId,
        text: text.trim(),
      );

      // Replace with confirmed response
      final updatedList = List<ChatMessageModel>.from(_activeConversation!.messages)
        ..removeWhere((m) => m.id == userMsg.id)
        ..add(userMsg.copyWith(isPending: false))
        ..add(assistantReply);

      _activeConversation = _activeConversation!.copyWith(
        messages: updatedList,
        lastMessagePreview: assistantReply.text,
        updatedAt: DateTime.now(),
      );

      _orbState = OrbState.speaking;
      notifyListeners();

      // Trigger Voice TTS
      await _voiceService.speak(
        assistantReply.text,
        onComplete: () {
          _orbState = OrbState.idle;
          notifyListeners();
        },
      );
    } catch (e) {
      _orbState = OrbState.error;
      _errorMessage = 'Transmission failed: $e';
      notifyListeners();
      await Future.delayed(const Duration(seconds: 2));
      _orbState = OrbState.idle;
      notifyListeners();
    }
  }

  void toggleVoiceMute() {
    _voiceService.setMuted(!_voiceService.isMuted);
    notifyListeners();
  }

  Future<void> triggerVoiceInput() async {
    if (_voiceService.isSpeaking) {
      await _voiceService.stopSpeaking();
      _orbState = OrbState.idle;
      notifyListeners();
      return;
    }

    if (_voiceService.isListening) {
      await _voiceService.stopListening();
      _orbState = OrbState.idle;
      notifyListeners();
      return;
    }

    _orbState = OrbState.listening;
    notifyListeners();

    await _voiceService.startListening(
      onResult: (spokenText) {
        sendChatMessage(spokenText);
      },
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
