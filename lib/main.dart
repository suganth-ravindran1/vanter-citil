import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/mind/presentation/bloc/mind_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  // Optional Firebase bootstrap — enable when google-services / GoogleService-Info exist:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authBloc = sl<AuthBloc>();
  runApp(FreeMindApp(authBloc: authBloc));
}

class FreeMindApp extends StatelessWidget {
  const FreeMindApp({super.key, required this.authBloc});

  final AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    final router = createRouter(authBloc);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider(create: (_) => sl<MindBloc>()),
      ],
      child: MaterialApp.router(
        title: 'FreeMind AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routerConfig: router,
      ),
    );
  }
}
