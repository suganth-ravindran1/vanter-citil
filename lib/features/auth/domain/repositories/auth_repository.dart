import 'package:dartz/dartz.dart';

import '../../../../core/utils/failures.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;

  Future<Either<Failure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, AppUser>> signInWithGoogle();
  Future<Either<Failure, AppUser>> signInWithApple();
  Future<Either<Failure, Unit>> sendPasswordReset(String email);
  Future<Either<Failure, AppUser>> completeProfile({
    required String name,
    required String language,
    required bool aiConsent,
  });
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, AppUser?>> restoreSession();
}
