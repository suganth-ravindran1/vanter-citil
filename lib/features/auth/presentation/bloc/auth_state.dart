part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  loading,
  authenticated,
  unauthenticated,
  needsProfile,
}

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.user,
    this.error,
    this.passwordResetSent = false,
  });

  const AuthState.unknown() : this(status: AuthStatus.unknown);
  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);
  const AuthState.authenticated(AppUser user)
      : this(status: AuthStatus.authenticated, user: user);
  const AuthState.needsProfile(AppUser user)
      : this(status: AuthStatus.needsProfile, user: user);

  final AuthStatus status;
  final AppUser? user;
  final String? error;
  final bool passwordResetSent;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? error,
    bool? passwordResetSent,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: clearError ? null : (error ?? this.error),
      passwordResetSent: passwordResetSent ?? this.passwordResetSent,
    );
  }

  @override
  List<Object?> get props => [status, user, error, passwordResetSent];
}
