import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/circle_icon_button.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/soft_card.dart';
import '../../domain/entities/toolkit_item.dart';

class ToolkitDetailPage extends StatefulWidget {
  const ToolkitDetailPage({super.key, required this.itemId});

  final String itemId;

  @override
  State<ToolkitDetailPage> createState() => _ToolkitDetailPageState();
}

class _ToolkitDetailPageState extends State<ToolkitDetailPage> {
  ToolkitItem? _item;
  bool _bookmarked = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final item = await sl<ToolkitRepository>().getById(widget.itemId);
    if (!mounted) return;
    setState(() => _item = item);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = _item;

    if (item == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isBook = item.category == 'book';
    final accent = isBook || item.category == 'cbt' || item.category == 'video'
        ? AppColors.lavenderDeep
        : AppColors.sageDeep;

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
                  const Spacer(),
                  CircleIconButton(
                    icon: _bookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
                    iconColor: accent,
                    onPressed: () => setState(() => _bookmarked = !_bookmarked),
                  ),
                  const SizedBox(width: 8),
                  CircleIconButton(icon: Icons.more_vert_rounded, onPressed: () {}),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 110,
                        height: 140,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          isBook ? Icons.menu_book_rounded : Icons.play_circle_fill_rounded,
                          size: 40,
                          color: accent,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: theme.textTheme.headlineSmall),
                            if (item.author != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                item.author!,
                                style: theme.textTheme.titleSmall?.copyWith(color: accent),
                              ),
                            ],
                            const SizedBox(height: 10),
                            if (item.tags.isNotEmpty)
                              Wrap(
                                spacing: 6,
                                children: item.tags
                                    .map(
                                      (t) => Chip(
                                        label: Text(t),
                                        backgroundColor: accent.withValues(alpha: 0.12),
                                        labelStyle: TextStyle(color: accent, fontSize: 12),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    )
                                    .toList(),
                              ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (item.rating != null) ...[
                                  const Icon(Icons.star_rounded, color: Color(0xFFE8B84A), size: 18),
                                  const SizedBox(width: 4),
                                  Text('${item.rating}', style: theme.textTheme.labelLarge),
                                  const SizedBox(width: 12),
                                ],
                                const Icon(Icons.schedule_rounded, size: 16, color: AppColors.textTertiary),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.durationMinutes} min',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text('About', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(item.description, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  SoftCard(
                    color: accent.withValues(alpha: 0.08),
                    shadow: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Key takeaways', style: theme.textTheme.titleSmall),
                        const SizedBox(height: 12),
                        Text('• Start small and stay consistent.', style: theme.textTheme.bodyMedium),
                        Text('• Notice thoughts without judgment.', style: theme.textTheme.bodyMedium),
                        Text('• Practice is progress.', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: PrimaryButton(
                label: isBook
                    ? 'Read Now'
                    : item.category == 'video'
                        ? 'Watch'
                        : 'Begin',
                color: accent,
                icon: isBook ? Icons.menu_book_rounded : Icons.play_arrow_rounded,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
