import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthGoogleRequested>(_onGoogle);
    on<AuthAppleRequested>(_onApple);
    on<AuthPasswordResetRequested>(_onReset);
    on<AuthProfileCompleted>(_onProfile);
    on<AuthLogoutRequested>(_onLogout);
  }

  final AuthRepository _repo;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _repo.restoreSession();
    result.fold(
      (f) => emit(state.copyWith(status: AuthStatus.unauthenticated, error: f.message)),
      (user) {
        if (user == null) {
          emit(const AuthState.unauthenticated());
        } else if (!user.profileComplete) {
          emit(AuthState.needsProfile(user));
        } else {
          emit(AuthState.authenticated(user));
        }
      },
    );
  }

  Future<void> _onLogin(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _repo.signInWithEmail(
      email: event.email.trim(),
      password: event.password,
    );
    _emitAuthResult(result, emit);
  }

  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _repo.registerWithEmail(
      email: event.email.trim(),
      password: event.password,
      name: event.name.trim(),
    );
    _emitAuthResult(result, emit);
  }

  Future<void> _onGoogle(AuthGoogleRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    _emitAuthResult(await _repo.signInWithGoogle(), emit);
  }

  Future<void> _onApple(AuthAppleRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    _emitAuthResult(await _repo.signInWithApple(), emit);
  }

  Future<void> _onReset(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _repo.sendPasswordReset(event.email.trim());
    result.fold(
      (f) => emit(state.copyWith(error: f.message)),
      (_) => emit(state.copyWith(passwordResetSent: true, clearError: true)),
    );
  }

  Future<void> _onProfile(
    AuthProfileCompleted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _repo.completeProfile(
      name: event.name,
      language: event.language,
      aiConsent: event.aiConsent,
    );
    result.fold(
      (f) => emit(state.copyWith(
        status: AuthStatus.needsProfile,
        error: f.message,
      )),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _repo.signOut();
    emit(const AuthState.unauthenticated());
  }

  void _emitAuthResult(
    dynamic result,
    Emitter<AuthState> emit,
  ) {
    result.fold(
      (f) => emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        error: f.message,
      )),
      (AppUser user) {
        if (!user.profileComplete) {
          emit(AuthState.needsProfile(user));
        } else {
          emit(AuthState.authenticated(user));
        }
      },
    );
  }
}
