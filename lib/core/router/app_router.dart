import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/profile_setup_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/journal/presentation/pages/journal_page.dart';
import '../../features/professional_support/presentation/pages/professional_support_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/shell/presentation/home_shell.dart';
import '../../features/sleep/presentation/pages/sleep_page.dart';
import '../../features/toolkit/presentation/pages/mind_body_page.dart';
import '../../features/toolkit/presentation/pages/resources_page.dart';
import '../../features/toolkit/presentation/pages/toolkit_detail_page.dart';

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final status = authBloc.state.status;
      final loc = state.matchedLocation;
      final onAuthFlow = loc == '/' || loc == '/login' || loc == '/profile-setup';

      if (status == AuthStatus.unknown) {
        return loc == '/' ? null : '/';
      }
      if (status == AuthStatus.unauthenticated) {
        return onAuthFlow && loc != '/profile-setup' ? null : '/login';
      }
      if (status == AuthStatus.needsProfile) {
        return loc == '/profile-setup' ? null : '/profile-setup';
      }
      if (status == AuthStatus.authenticated && onAuthFlow) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SplashPage()),
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/profile-setup', builder: (_, _) => const ProfileSetupPage()),
      GoRoute(path: '/home', builder: (_, _) => const HomeShell()),
      GoRoute(path: '/journal', builder: (_, _) => const JournalPage()),
      GoRoute(path: '/sleep', builder: (_, _) => const SleepPage()),
      GoRoute(path: '/support', builder: (_, _) => const ProfessionalSupportPage()),
      GoRoute(
        path: '/support/chat/:id',
        builder: (_, state) => TherapistChatPage(
          therapistId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsPage()),
      GoRoute(path: '/privacy', builder: (_, _) => const PrivacyPage()),
      GoRoute(path: '/about', builder: (_, _) => const AboutPage()),
      GoRoute(path: '/toolkit/mind-body', builder: (_, _) => const MindBodyPage()),
      GoRoute(path: '/toolkit/resources', builder: (_, _) => const ResourcesPage()),
      GoRoute(
        path: '/toolkit/item/:id',
        builder: (_, state) => ToolkitDetailPage(itemId: state.pathParameters['id']!),
      ),
    ],
  );
}

/// Bridges Bloc streams to GoRouter refresh.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
