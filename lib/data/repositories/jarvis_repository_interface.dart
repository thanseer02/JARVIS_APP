import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

abstract class IJarvisRepository {
  Future<bool> checkBackendHealth();
  Future<List<ConversationModel>> getConversations();
  Future<ConversationModel?> getConversationById(String id);
  Future<ConversationModel> createConversation({String? initialTitle});
  Future<bool> deleteConversation(String id);
  Future<ChatMessageModel> sendMessage({
    required String conversationId,
    required String text,
  });
}
