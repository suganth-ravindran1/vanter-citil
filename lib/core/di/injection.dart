import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/journal/data/repositories/journal_repository_impl.dart';
import '../../features/mind/data/repositories/chat_repository_impl.dart';
import '../../features/mind/domain/repositories/chat_repository.dart';
import '../../features/mind/presentation/bloc/mind_bloc.dart';
import '../../features/sleep/presentation/pages/sleep_page.dart';
import '../../features/toolkit/domain/entities/toolkit_item.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  const secure = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  sl
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerSingleton<FlutterSecureStorage>(secure)
    ..registerLazySingleton<ApiClient>(ApiClient.new)
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(secureStorage: sl(), prefs: sl()),
    )
    ..registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(apiClient: sl(), prefs: sl()),
    )
    ..registerLazySingleton<JournalRepositoryImpl>(
      () => JournalRepositoryImpl(sl()),
    )
    ..registerLazySingleton<ToolkitRepository>(ToolkitRepository.new)
    ..registerLazySingleton<SleepRepository>(() => SleepRepository(sl()))
    ..registerFactory(() => AuthBloc(sl()))
    ..registerFactory(() => MindBloc(sl()));
}
