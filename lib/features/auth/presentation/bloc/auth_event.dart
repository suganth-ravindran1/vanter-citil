part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });
  final String email;
  final String password;
  final String name;

  @override
  List<Object?> get props => [email, password, name];
}

class AuthGoogleRequested extends AuthEvent {
  const AuthGoogleRequested();
}

class AuthAppleRequested extends AuthEvent {
  const AuthAppleRequested();
}

class AuthPasswordResetRequested extends AuthEvent {
  const AuthPasswordResetRequested(this.email);
  final String email;

  @override
  List<Object?> get props => [email];
}

class AuthProfileCompleted extends AuthEvent {
  const AuthProfileCompleted({
    required this.name,
    required this.language,
    required this.aiConsent,
  });
  final String name;
  final String language;
  final bool aiConsent;

  @override
  List<Object?> get props => [name, language, aiConsent];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
