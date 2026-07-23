import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/circle_icon_button.dart';
import '../../../../shared/widgets/soft_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<AuthBloc>().state.user;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Row(
              children: [
                CircleIconButton(
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => context.pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Settings', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 20),
            SoftCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.lavenderSoft,
                    child: Text(
                      (user?.displayName ?? 'U').substring(0, 1).toUpperCase(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.lavenderDeep,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.displayName ?? 'Guest', style: theme.textTheme.titleMedium),
                        Text(user?.email ?? '', style: theme.textTheme.bodySmall),
                        Text(
                          'Language: ${user?.language ?? 'English'}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SoftCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.language_rounded),
                    title: const Text('Language'),
                    subtitle: Text(user?.language ?? 'English'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _pickLanguage(context),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.notifications_outlined),
                    title: const Text('Notifications'),
                    trailing: Switch(
                      value: true,
                      activeThumbColor: AppColors.lavenderDeep,
                      onChanged: (_) {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SoftCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout_rounded, color: AppColors.danger),
                title: Text(
                  'Sign out',
                  style: theme.textTheme.titleSmall?.copyWith(color: AppColors.danger),
                ),
                onTap: () {
                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                  context.go('/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickLanguage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: [
            Text('Preferred language', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...AppConstants.supportedLanguages.map(
              (l) => ListTile(
                title: Text(l),
                onTap: () {
                  final user = context.read<AuthBloc>().state.user;
                  if (user != null) {
                    context.read<AuthBloc>().add(
                          AuthProfileCompleted(
                            name: user.displayName ?? '',
                            language: l,
                            aiConsent: user.aiConsent,
                          ),
                        );
                  }
                  Navigator.pop(ctx);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<AuthBloc>().state.user;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Row(
              children: [
                CircleIconButton(
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => context.pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Privacy', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Your chats, journals, and sleep records stay under your control.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            SoftCard(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('AI personalization'),
                subtitle: const Text(
                  'Allow FreeMind to use prior conversations and journals to personalize replies.',
                ),
                value: user?.aiConsent ?? false,
                activeThumbColor: AppColors.lavenderDeep,
                onChanged: (v) {
                  if (user == null) return;
                  context.read<AuthBloc>().add(
                        AuthProfileCompleted(
                          name: user.displayName ?? '',
                          language: user.language,
                          aiConsent: v,
                        ),
                      );
                },
              ),
            ),
            const SizedBox(height: 16),
            SoftCard(
              color: AppColors.lavenderMist,
              shadow: false,
              child: Text(
                'Data is stored securely on-device for this MVP and can sync to Firebase / FastAPI when configured. FreeMind is not a crisis service.',
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lavenderDeep),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Row(
              children: [
                CircleIconButton(
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => context.pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.lavenderSoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.eco_rounded, size: 40, color: AppColors.lavenderDeep),
                  ),
                  const SizedBox(height: 16),
                  Text('FreeMind AI', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text('Since 2026', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 16),
                  Text(
                    'A calm AI mental wellness companion — supportive, multilingual, and designed with care.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  SoftCard(
                    color: AppColors.lavenderMist,
                    shadow: false,
                    child: Text(
                      'FreeMind AI offers emotional support and wellness tools. It is not a substitute for professional care or emergency services.',
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lavenderDeep),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
