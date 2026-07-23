import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  const JournalEntry({
    required this.id,
    required this.content,
    required this.createdAt,
    this.aiReply,
  });

  final String id;
  final String content;
  final DateTime createdAt;
  final String? aiReply;

  bool get hasAiReply => aiReply != null && aiReply!.isNotEmpty;

  JournalEntry copyWith({String? content, String? aiReply}) {
    return JournalEntry(
      id: id,
      content: content ?? this.content,
      createdAt: createdAt,
      aiReply: aiReply ?? this.aiReply,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'aiReply': aiReply,
      };

  factory JournalEntry.fromMap(Map<String, dynamic> map) => JournalEntry(
        id: map['id'] as String,
        content: map['content'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        aiReply: map['aiReply'] as String?,
      );

  @override
  List<Object?> get props => [id, content, createdAt, aiReply];
}
