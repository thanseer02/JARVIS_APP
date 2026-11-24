import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../services/jarvis_ai_service.dart';

class ChatViewModel extends ChangeNotifier {
  final JarvisAiService _aiService = JarvisAiService();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Greetings. I am JARVIS. How may I be of service to you today?",
      isUser: false,
    ),
  ];

  bool _isTyping = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  Future<void> sendMessage(String text) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    // 1. Add user message
    _messages.add(ChatMessage(text: trimmedText, isUser: true));
    _isTyping = true;
    notifyListeners();

    try {
      // 2. Fetch response from Genkit Google GenAI
      final reply = await _aiService.generateResponse(trimmedText);

      _messages.add(
        ChatMessage(
          text: reply,
          isUser: false,
        ),
      );
    } catch (e) {
      _messages.add(
        ChatMessage(
          text: "An error occurred: $e",
          isUser: false,
        ),
      );
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    _messages.add(
      ChatMessage(
        text: "Systems cleared. Ready for your instructions, sir.",
        isUser: false,
      ),
    );
    _isTyping = false;
    notifyListeners();
  }
}
