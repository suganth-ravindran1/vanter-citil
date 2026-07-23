import '../../../../core/constants/app_constants.dart';
import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<List<ChatMessage>> getHistory(String userId);
  Future<void> saveMessage(String userId, ChatMessage message);
  Future<void> clearHistory(String userId);

  /// Streams assistant tokens. Falls back to local CBT-style replies if API is offline.
  Stream<String> streamReply({
    required String userId,
    required String message,
    required AiMode mode,
    required String language,
    required bool usePersonalization,
    required List<ChatMessage> history,
  });
}
