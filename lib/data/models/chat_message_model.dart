enum MessageSender { user, assistant, system }

class ChatMessageModel {
  final String id;
  final String conversationId;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isError;
  final bool isPending;

  ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.isError = false,
    this.isPending = false,
  });

  bool get isUser => sender == MessageSender.user;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      text: json['text'] as String? ?? '',
      sender: json['sender'] == 'user'
          ? MessageSender.user
          : MessageSender.assistant,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      isError: json['isError'] as bool? ?? false,
      isPending: json['isPending'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'text': text,
      'sender': sender == MessageSender.user ? 'user' : 'assistant',
      'timestamp': timestamp.toIso8601String(),
      'isError': isError,
      'isPending': isPending,
    };
  }

  ChatMessageModel copyWith({
    String? id,
    String? conversationId,
    String? text,
    MessageSender? sender,
    DateTime? timestamp,
    bool? isError,
    bool? isPending,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      isError: isError ?? this.isError,
      isPending: isPending ?? this.isPending,
    );
  }
}
