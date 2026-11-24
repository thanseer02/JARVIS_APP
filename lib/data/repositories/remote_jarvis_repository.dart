import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';
import '../services/jarvis_api_client.dart';
import 'jarvis_repository_interface.dart';

class RemoteJarvisRepository implements IJarvisRepository {
  final JarvisApiClient _apiClient;

  RemoteJarvisRepository(this._apiClient);

  @override
  Future<bool> checkBackendHealth() async {
    return await _apiClient.checkHealth();
  }

  @override
  Future<List<ConversationModel>> getConversations() async {
    try {
      final response = await _apiClient.dio.get('/api/conversations');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map(
              (item) =>
                  ConversationModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<ConversationModel?> getConversationById(String id) async {
    try {
      final response = await _apiClient.dio.get('/api/conversations/$id');
      if (response.statusCode == 200 && response.data != null) {
        return ConversationModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ConversationModel> createConversation({String? initialTitle}) async {
    final response = await _apiClient.dio.post(
      '/api/conversations',
      data: {
        'title':
            initialTitle ??
            'Protocol ${DateTime.now().hour}:${DateTime.now().minute}',
      },
    );
    return ConversationModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<bool> deleteConversation(String id) async {
    try {
      final response = await _apiClient.dio.delete('/api/conversations/$id');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<ChatMessageModel> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    final response = await _apiClient.dio.post(
      '/api/chat',
      data: {'conversationId': conversationId, 'message': text},
    );
    final data = response.data as Map<String, dynamic>;
    if (data.containsKey('message') && data['message'] is Map) {
      return ChatMessageModel.fromJson(data['message'] as Map<String, dynamic>);
    }
    return ChatMessageModel.fromJson(data);
  }
}
