import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

part 'mind_event.dart';
part 'mind_state.dart';

class MindBloc extends Bloc<MindEvent, MindState> {
  MindBloc(this._repo) : super(const MindState()) {
    on<MindStarted>(_onStarted);
    on<MindModeChanged>(_onModeChanged);
    on<MindSendMessage>(_onSend);
    on<MindClearHistory>(_onClear);
    on<MindAffirmationTick>(_onAffirmation);
  }

  final ChatRepository _repo;
  static const _uuid = Uuid();

  Future<void> _onStarted(MindStarted event, Emitter<MindState> emit) async {
    emit(state.copyWith(isLoading: true, userId: event.userId, language: event.language));
    final history = await _repo.getHistory(event.userId);
    emit(state.copyWith(
      isLoading: false,
      messages: history,
      affirmationIndex: 0,
    ));
  }

  void _onModeChanged(MindModeChanged event, Emitter<MindState> emit) {
    emit(state.copyWith(mode: event.mode));
  }

  void _onAffirmation(MindAffirmationTick event, Emitter<MindState> emit) {
    final next = (state.affirmationIndex + 1) % AppConstants.affirmations.length;
    emit(state.copyWith(affirmationIndex: next));
  }

  Future<void> _onClear(MindClearHistory event, Emitter<MindState> emit) async {
    await _repo.clearHistory(state.userId!);
    emit(state.copyWith(messages: [], clearError: true));
  }

  Future<void> _onSend(MindSendMessage event, Emitter<MindState> emit) async {
    final text = event.text.trim();
    if (text.isEmpty || state.userId == null || state.isStreaming) return;

    final userMsg = ChatMessage(
      id: _uuid.v4(),
      role: MessageRole.user,
      content: text,
      createdAt: DateTime.now(),
    );
    final assistantId = _uuid.v4();
    final assistantMsg = ChatMessage(
      id: assistantId,
      role: MessageRole.assistant,
      content: '',
      createdAt: DateTime.now(),
      isStreaming: true,
    );

    final withUser = [...state.messages, userMsg, assistantMsg];
    emit(state.copyWith(messages: withUser, isStreaming: true, clearError: true));
    await _repo.saveMessage(state.userId!, userMsg);

    var assembled = '';
    try {
      await for (final token in _repo.streamReply(
        userId: state.userId!,
        message: text,
        mode: state.mode,
        language: state.language,
        usePersonalization: event.usePersonalization,
        history: state.messages,
      )) {
        assembled += token;
        final updated = state.messages.map((m) {
          if (m.id == assistantId) {
            return m.copyWith(content: assembled, isStreaming: true);
          }
          return m;
        }).toList();
        emit(state.copyWith(messages: updated));
      }

      final finalMsg = ChatMessage(
        id: assistantId,
        role: MessageRole.assistant,
        content: assembled.trim().isEmpty
            ? 'I\'m here with you. Tell me a little more when you\'re ready.'
            : assembled.trim(),
        createdAt: DateTime.now(),
      );
      final finalized = state.messages.map((m) {
        if (m.id == assistantId) return finalMsg;
        return m;
      }).toList();
      await _repo.saveMessage(state.userId!, finalMsg);
      emit(state.copyWith(messages: finalized, isStreaming: false));
    } catch (e) {
      emit(state.copyWith(
        isStreaming: false,
        error: 'Could not reach FreeMind AI. Showing a gentle local reply.',
      ));
    }
  }
}
