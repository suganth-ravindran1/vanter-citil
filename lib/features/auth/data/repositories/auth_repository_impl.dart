import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/failures.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Local-first auth repository ready to swap for Firebase Auth.
/// Persist session + profile securely; social buttons are stubbed for MVP
/// until Firebase / OAuth keys are configured.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences prefs,
  })  : _secure = secureStorage,
        _prefs = prefs;

  final FlutterSecureStorage _secure;
  final SharedPreferences _prefs;
  final _controller = StreamController<AppUser?>.broadcast();
  AppUser? _user;
  static const _uuid = Uuid();

  static const _kUserId = 'fm_user_id';
  static const _kEmail = 'fm_email';
  static const _kPasswordPrefix = 'fm_pwd_';

  @override
  Stream<AppUser?> get authStateChanges => _controller.stream;

  @override
  AppUser? get currentUser => _user;

  @override
  Future<Either<Failure, AppUser?>> restoreSession() async {
    try {
      final id = await _secure.read(key: _kUserId);
      if (id == null) {
        _emit(null);
        return const Right(null);
      }
      final user = _readProfile(id);
      _emit(user);
      return Right(user);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final storedId = _prefs.getString('email_user_$email');
      if (storedId == null) {
        return const Left(AuthFailure('No account found for this email.'));
      }
      final storedPwd = await _secure.read(key: '$_kPasswordPrefix$storedId');
      if (storedPwd != password) {
        return const Left(AuthFailure('Incorrect password.'));
      }
      final user = _readProfile(storedId);
      await _secure.write(key: _kUserId, value: storedId);
      await _secure.write(key: _kEmail, value: email);
      _emit(user);
      return Right(user);
    } catch (_) {
      return const Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, AppUser>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      if (_prefs.containsKey('email_user_$email')) {
        return const Left(AuthFailure('An account already exists for this email.'));
      }
      final id = _uuid.v4();
      final user = AppUser(
        id: id,
        email: email,
        displayName: name,
        profileComplete: false,
      );
      await _prefs.setString('email_user_$email', id);
      await _secure.write(key: '$_kPasswordPrefix$id', value: password);
      await _writeProfile(user);
      await _secure.write(key: _kUserId, value: id);
      await _secure.write(key: _kEmail, value: email);
      _emit(user);
      return Right(user);
    } catch (_) {
      return const Left(AuthFailure('Could not create account.'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithGoogle() async {
    // Ready for Firebase GoogleSignIn — demo identity for local MVP.
    return _socialSignIn(
      email: 'google.user@freemind.ai',
      name: 'FreeMind User',
      provider: 'google',
    );
  }

  @override
  Future<Either<Failure, AppUser>> signInWithApple() async {
    return _socialSignIn(
      email: 'apple.user@freemind.ai',
      name: 'FreeMind User',
      provider: 'apple',
    );
  }

  Future<Either<Failure, AppUser>> _socialSignIn({
    required String email,
    required String name,
    required String provider,
  }) async {
    try {
      var id = _prefs.getString('email_user_$email');
      late AppUser user;
      if (id == null) {
        id = _uuid.v4();
        user = AppUser(
          id: id,
          email: email,
          displayName: name,
          profileComplete: false,
        );
        await _prefs.setString('email_user_$email', id);
        await _prefs.setString('provider_$id', provider);
        await _writeProfile(user);
      } else {
        user = _readProfile(id);
      }
      await _secure.write(key: _kUserId, value: id);
      await _secure.write(key: _kEmail, value: email);
      _emit(user);
      return Right(user);
    } catch (_) {
      return const Left(AuthFailure('Social sign-in failed.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordReset(String email) async {
    if (!_prefs.containsKey('email_user_$email')) {
      return const Left(AuthFailure('No account found for this email.'));
    }
    // Hook: Firebase Auth sendPasswordResetEmail
    return const Right(unit);
  }

  @override
  Future<Either<Failure, AppUser>> completeProfile({
    required String name,
    required String language,
    required bool aiConsent,
  }) async {
    final current = _user;
    if (current == null) return const Left(AuthFailure('Not signed in.'));
    final updated = current.copyWith(
      displayName: name,
      language: language,
      aiConsent: aiConsent,
      profileComplete: true,
    );
    await _writeProfile(updated);
    _emit(updated);
    return Right(updated);
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    await _secure.delete(key: _kUserId);
    await _secure.delete(key: _kEmail);
    _emit(null);
    return const Right(unit);
  }

  AppUser _readProfile(String id) {
    return AppUser(
      id: id,
      email: _prefs.getString('profile_email_$id') ?? '',
      displayName: _prefs.getString('profile_name_$id'),
      photoUrl: _prefs.getString('profile_photo_$id'),
      language: _prefs.getString('profile_lang_$id') ?? 'English',
      aiConsent: _prefs.getBool('profile_consent_$id') ?? false,
      profileComplete: _prefs.getBool('profile_complete_$id') ?? false,
    );
  }

  Future<void> _writeProfile(AppUser user) async {
    await _prefs.setString('profile_email_${user.id}', user.email);
    if (user.displayName != null) {
      await _prefs.setString('profile_name_${user.id}', user.displayName!);
    }
    await _prefs.setString('profile_lang_${user.id}', user.language);
    await _prefs.setBool('profile_consent_${user.id}', user.aiConsent);
    await _prefs.setBool('profile_complete_${user.id}', user.profileComplete);
  }

  void _emit(AppUser? user) {
    _user = user;
    _controller.add(user);
  }
}
