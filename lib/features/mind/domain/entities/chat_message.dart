import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';

enum MessageRole { user, assistant, system }

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.isStreaming = false,
  });

  final String id;
  final MessageRole role;
  final String content;
  final DateTime createdAt;
  final bool isStreaming;

  ChatMessage copyWith({
    String? content,
    bool? isStreaming,
  }) {
    return ChatMessage(
      id: id,
      role: role,
      content: content ?? this.content,
      createdAt: createdAt,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'role': role.name,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
        id: map['id'] as String,
        role: MessageRole.values.byName(map['role'] as String),
        content: map['content'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );

  @override
  List<Object?> get props => [id, role, content, createdAt, isStreaming];
}

class Conversation extends Equatable {
  const Conversation({
    required this.id,
    required this.messages,
    required this.updatedAt,
    this.mode = AiMode.generalSupport,
    this.title,
  });

  final String id;
  final List<ChatMessage> messages;
  final DateTime updatedAt;
  final AiMode mode;
  final String? title;

  @override
  List<Object?> get props => [id, messages, updatedAt, mode, title];
}
