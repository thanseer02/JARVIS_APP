import 'dart:async';

import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';
import 'jarvis_repository_interface.dart';

class MockJarvisRepository implements IJarvisRepository {
  final List<ConversationModel> _mockConversations = [
    ConversationModel(
      id: 'conv_alpha_01',
      title: 'Neural Core Diagnostic',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 25)),
      lastMessagePreview:
          'All subsystems calibrated. Quantum efficiency 99.4%.',
      messages: [
        ChatMessageModel(
          id: 'msg_01',
          conversationId: 'conv_alpha_01',
          text: 'Initiate system diagnostic protocol.',
          sender: MessageSender.user,
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        ChatMessageModel(
          id: 'msg_02',
          conversationId: 'conv_alpha_01',
          text: 'Running full diagnostics on all modules. Memory integrity verified. Processing core online.',
          sender: MessageSender.assistant,
          timestamp: DateTime.now().subtract(
            const Duration(hours: 3, minutes: -1),
          ),
        ),
        ChatMessageModel(
          id: 'msg_03',
          conversationId: 'conv_alpha_01',
          text: 'What is our current quantum efficiency rate?',
          sender: MessageSender.user,
          timestamp: DateTime.now().subtract(const Duration(minutes: 26)),
        ),
        ChatMessageModel(
          id: 'msg_04',
          conversationId: 'conv_alpha_01',
          text: 'All subsystems calibrated. Quantum efficiency 99.4%. Ready for autonomous task delegation, sir.',
          sender: MessageSender.assistant,
          timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        ),
      ],
    ),
    ConversationModel(
      id: 'conv_beta_02',
      title: 'Orbital Telemetry Briefing',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
      lastMessagePreview: 'Telemetry stream locked onto orbital station relay.',
      messages: [
        ChatMessageModel(
          id: 'msg_10',
          conversationId: 'conv_beta_02',
          text: 'Lock telemetry coordinates for satellite link Alpha-9.',
          sender: MessageSender.user,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ChatMessageModel(
          id: 'msg_11',
          conversationId: 'conv_beta_02',
          text: 'Telemetry stream locked onto orbital station relay. Channel encrypted with 4096-bit quantum cipher.',
          sender: MessageSender.assistant,
          timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        ),
      ],
    ),
  ];

  @override
  Future<bool> checkBackendHealth() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<List<ConversationModel>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_mockConversations);
  }

  @override
  Future<ConversationModel?> getConversationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockConversations.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ConversationModel> createConversation({String? initialTitle}) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final newConv = ConversationModel(
      id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
      title:
          initialTitle ??
          'Protocol ${DateTime.now().hour}:${DateTime.now().minute}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastMessagePreview: 'Initiated new channel.',
      messages: [],
    );
    _mockConversations.insert(0, newConv);
    return newConv;
  }

  @override
  Future<bool> deleteConversation(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockConversations.removeWhere((c) => c.id == id);
    return true;
  }

  @override
  Future<ChatMessageModel> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1400));

    final replyText = _generateFuturisticReply(text);
    final responseMsg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      text: replyText,
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
    );

    final convIndex = _mockConversations.indexWhere(
      (c) => c.id == conversationId,
    );
    if (convIndex != -1) {
      final conv = _mockConversations[convIndex];
      final updatedList = List<ChatMessageModel>.from(conv.messages)
        ..add(
          ChatMessageModel(
            id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
            conversationId: conversationId,
            text: text,
            sender: MessageSender.user,
            timestamp: DateTime.now().subtract(
              const Duration(milliseconds: 1300),
            ),
          ),
        )
        ..add(responseMsg);

      _mockConversations[convIndex] = conv.copyWith(
        messages: updatedList,
        lastMessagePreview: replyText,
        updatedAt: DateTime.now(),
      );
    }

    return responseMsg;
  }

  String _generateFuturisticReply(String userPrompt) {
    final lower = userPrompt.toLowerCase();
    if (lower.contains('status') || lower.contains('diagnostics')) {
      return "Subsystems online, sir. Core temperature optimal at 38°C. Neural pathways synchronized.";
    } else if (lower.contains('who are you') || lower.contains('introduce')) {
      return "I am JARVIS — Just A Rather Very Intelligent System. Your personal neural interface and tactical coordinator.";
    } else if (lower.contains('weather') || lower.contains('forecast')) {
      return "Atmospheric analysis indicates 22°C with clear ionic conditions. Precipitation probability is below 5%.";
    } else if (lower.contains('secure') || lower.contains('protocol')) {
      return "Security protocols elevated to DEFCON-2. Quantum encryptions rotating every 60 seconds.";
    } else {
      return "Affirmative, sir. Processing request: \"$userPrompt\". Analyzing multi-node telemetry and deploying corresponding protocols immediately.";
    }
  }
}
