import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/freemind_logo.dart';
import '../bloc/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.authenticated:
            context.go('/home');
          case AuthStatus.needsProfile:
            context.go('/profile-setup');
          case AuthStatus.unauthenticated:
            context.go('/login');
          case AuthStatus.unknown:
          case AuthStatus.loading:
            break;
        }
      },
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FreeMindLogo(size: 140),
              SizedBox(height: 24),
              Text(
                'FreeMind AI',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your calm companion',
                style: TextStyle(color: Color(0xFF6B6B76)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
