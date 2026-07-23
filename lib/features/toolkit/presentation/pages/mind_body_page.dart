import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/circle_icon_button.dart';
import '../../../../shared/widgets/soft_card.dart';
import '../../domain/entities/toolkit_item.dart';

class MindBodyPage extends StatefulWidget {
  const MindBodyPage({super.key});

  @override
  State<MindBodyPage> createState() => _MindBodyPageState();
}

class _MindBodyPageState extends State<MindBodyPage> {
  MindBodyType _tab = MindBodyType.exercise;
  List<ToolkitItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final items = await sl<ToolkitRepository>().getMindBody(_tab);
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Color get _accent => switch (_tab) {
        MindBodyType.exercise => AppColors.sage,
        MindBodyType.meditation => AppColors.lavender,
        MindBodyType.yoga => const Color(0xFFD4A574),
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Mind & Body', style: theme.textTheme.headlineMedium),
                            const SizedBox(width: 8),
                            Icon(Icons.eco_rounded, color: _accent, size: 22),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Move, breathe and reset.', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Icon(Icons.self_improvement_rounded, size: 64, color: _accent.withValues(alpha: 0.25)),
                ],
              ),
            ),
            SoftCard(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: MindBodyType.values.map((t) {
                  final selected = t == _tab;
                  final color = switch (t) {
                    MindBodyType.exercise => AppColors.sage,
                    MindBodyType.meditation => AppColors.lavender,
                    MindBodyType.yoga => const Color(0xFFD4A574),
                  };
                  final icon = switch (t) {
                    MindBodyType.exercise => Icons.directions_run_rounded,
                    MindBodyType.meditation => Icons.spa_outlined,
                    MindBodyType.yoga => Icons.self_improvement_rounded,
                  };
                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() => _tab = t);
                        _load();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Icon(icon, color: selected ? color : AppColors.textTertiary),
                            const SizedBox(height: 4),
                            Text(
                              t.name[0].toUpperCase() + t.name.substring(1),
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: selected ? color : AppColors.textTertiary,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 3,
                              width: selected ? 28 : 0,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Quick Picks', style: theme.textTheme.titleMedium),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: _items.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        if (i == _items.length) {
                          return SoftCard(
                            color: AppColors.sageMist,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month_outlined, color: AppColors.sageDeep),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Small steps every day lead to big changes.',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: AppColors.sageDeep,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.sageDeep,
                                  ),
                                  onPressed: () {},
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Start Your Routine'),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward_rounded, size: 18),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        final item = _items[i];
                        return SoftCard(
                          onTap: () => context.push('/toolkit/item/${item.id}'),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: _accent.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      Icons.fitness_center_rounded,
                                      color: _accent,
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.45),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${item.durationMinutes} min',
                                        style: const TextStyle(color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title, style: theme.textTheme.titleSmall),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
