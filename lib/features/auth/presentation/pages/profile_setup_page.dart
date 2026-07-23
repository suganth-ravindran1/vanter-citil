import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/freemind_logo.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/soft_card.dart';
import '../bloc/auth_bloc.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  late final TextEditingController _name;
  String _language = 'English';
  bool _aiConsent = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state.user;
    _name = TextEditingController(text: user?.displayName ?? '');
    _language = user?.language ?? 'English';
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go('/home');
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: FreeMindLogo(size: 96, showMountains: false)),
                const SizedBox(height: 20),
                Text('Set up your space', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'A few details help FreeMind support you gently and personally.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 28),
                SoftCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your name', style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _name,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(hintText: 'What should we call you?'),
                      ),
                      const SizedBox(height: 20),
                      Text('Preferred language', style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _language,
                        items: AppConstants.supportedLanguages
                            .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                            .toList(),
                        onChanged: (v) => setState(() => _language = v ?? 'English'),
                        decoration: const InputDecoration(),
                      ),
                      const SizedBox(height: 20),
                      SoftCard(
                        color: AppColors.lavenderMist,
                        shadow: false,
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _aiConsent,
                              activeColor: AppColors.lavenderDeep,
                              onChanged: (v) => setState(() => _aiConsent = v ?? false),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'I consent to FreeMind personalizing responses using my chats and journals. I can change this anytime in Privacy.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return PrimaryButton(
                            label: 'Continue',
                            isLoading: state.isLoading,
                            onPressed: () {
                              if (_name.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter your name.')),
                                );
                                return;
                              }
                              if (!_aiConsent) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please accept AI personalization consent to continue.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              context.read<AuthBloc>().add(
                                    AuthProfileCompleted(
                                      name: _name.text.trim(),
                                      language: _language,
                                      aiConsent: _aiConsent,
                                    ),
                                  );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
