import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/soft_card.dart';
import '../../mind/presentation/pages/mind_page.dart';
import '../../toolkit/presentation/pages/toolkit_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const _FreeMindDrawer(),
      body: IndexedStack(
        index: _index,
        children: [
          MindPage(onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer()),
          ToolkitPage(onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer()),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  activeIcon: Icons.chat_bubble_rounded,
                  label: 'Mind',
                  selected: _index == 0,
                  onTap: () => setState(() => _index = 0),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.work_outline_rounded,
                  activeIcon: Icons.work_rounded,
                  label: 'Toolkit',
                  selected: _index == 1,
                  onTap: () => setState(() => _index = 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.lavenderDeep : AppColors.textTertiary;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: selected ? 5 : 0,
              height: selected ? 5 : 0,
              decoration: const BoxDecoration(
                color: AppColors.lavenderDeep,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FreeMindDrawer extends StatelessWidget {
  const _FreeMindDrawer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.lavenderSoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.eco_rounded, color: AppColors.lavenderDeep),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('FreeMind', style: AppTypography.brand(context)),
                      Text('Your mind matters.', style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _DrawerCard(
                icon: Icons.menu_book_rounded,
                title: "Today's Journal",
                subtitle: 'Reflection of your day.',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/journal');
                },
              ),
              const SizedBox(height: 12),
              _DrawerCard(
                icon: Icons.nightlight_round,
                title: 'Sleep Recovery',
                subtitle: 'Personalized plans.',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/sleep');
                },
              ),
              const SizedBox(height: 12),
              _DrawerCard(
                icon: Icons.favorite_outline_rounded,
                title: 'Need Additional Support',
                subtitle: 'Connect with a psychologist.',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/support');
                },
              ),
              const SizedBox(height: 20),
              _DrawerLink(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/settings');
                },
              ),
              _DrawerLink(
                icon: Icons.shield_outlined,
                label: 'Privacy',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/privacy');
                },
              ),
              _DrawerLink(
                icon: Icons.info_outline_rounded,
                label: 'About FreeMind',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/about');
                },
              ),
              const Spacer(),
              SoftCard(
                color: AppColors.lavenderMist,
                shadow: false,
                child: Row(
                  children: [
                    const Icon(Icons.eco_rounded, color: AppColors.lavenderDeep),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Be kind to your mind. You're doing your best.",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.lavenderDeep,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerCard extends StatelessWidget {
  const _DrawerCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      color: const Color(0xFFF3F3F6),
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.lavenderDeep),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}

class _DrawerLink extends StatelessWidget {
  const _DrawerLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      onTap: onTap,
    );
  }
}
