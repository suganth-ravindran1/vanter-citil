part of 'mind_bloc.dart';

class MindState extends Equatable {
  const MindState({
    this.userId,
    this.messages = const [],
    this.mode = AiMode.generalSupport,
    this.language = 'English',
    this.isLoading = false,
    this.isStreaming = false,
    this.affirmationIndex = 0,
    this.error,
  });

  final String? userId;
  final List<ChatMessage> messages;
  final AiMode mode;
  final String language;
  final bool isLoading;
  final bool isStreaming;
  final int affirmationIndex;
  final String? error;

  String get affirmation => AppConstants.affirmations[affirmationIndex];

  MindState copyWith({
    String? userId,
    List<ChatMessage>? messages,
    AiMode? mode,
    String? language,
    bool? isLoading,
    bool? isStreaming,
    int? affirmationIndex,
    String? error,
    bool clearError = false,
  }) {
    return MindState(
      userId: userId ?? this.userId,
      messages: messages ?? this.messages,
      mode: mode ?? this.mode,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
      isStreaming: isStreaming ?? this.isStreaming,
      affirmationIndex: affirmationIndex ?? this.affirmationIndex,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        userId,
        messages,
        mode,
        language,
        isLoading,
        isStreaming,
        affirmationIndex,
        error,
      ];
}
