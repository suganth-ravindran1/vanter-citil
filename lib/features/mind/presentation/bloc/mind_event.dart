part of 'mind_bloc.dart';

abstract class MindEvent extends Equatable {
  const MindEvent();
  @override
  List<Object?> get props => [];
}

class MindStarted extends MindEvent {
  const MindStarted({required this.userId, required this.language});
  final String userId;
  final String language;
  @override
  List<Object?> get props => [userId, language];
}

class MindModeChanged extends MindEvent {
  const MindModeChanged(this.mode);
  final AiMode mode;
  @override
  List<Object?> get props => [mode];
}

class MindSendMessage extends MindEvent {
  const MindSendMessage(this.text, {this.usePersonalization = true});
  final String text;
  final bool usePersonalization;
  @override
  List<Object?> get props => [text, usePersonalization];
}

class MindClearHistory extends MindEvent {
  const MindClearHistory();
}

class MindAffirmationTick extends MindEvent {
  const MindAffirmationTick();
}
