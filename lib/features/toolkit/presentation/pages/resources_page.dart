import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/circle_icon_button.dart';
import '../../../../shared/widgets/soft_card.dart';
import '../../domain/entities/toolkit_item.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  ResourceType _tab = ResourceType.book;
  List<ToolkitItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final items = await sl<ToolkitRepository>().getResources(_tab);
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  String get _tabLabel => switch (_tab) {
        ResourceType.book => 'Books',
        ResourceType.video => 'Videos',
        ResourceType.cbtTechnique => 'CBT Techniques',
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
                  const Spacer(),
                  CircleIconButton(icon: Icons.more_vert_rounded, onPressed: () {}),
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
                            Text('Resources', style: theme.textTheme.headlineMedium),
                            const SizedBox(width: 8),
                            const Icon(Icons.menu_book_outlined, color: AppColors.lavender),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Learn, explore and grow.', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.local_library_outlined,
                    size: 56,
                    color: AppColors.lavender.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
            SoftCard(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Row(
                children: ResourceType.values.map((t) {
                  final selected = t == _tab;
                  final label = switch (t) {
                    ResourceType.book => 'Books',
                    ResourceType.video => 'Videos',
                    ResourceType.cbtTechnique => 'Techniques',
                  };
                  final icon = switch (t) {
                    ResourceType.book => Icons.menu_book_rounded,
                    ResourceType.video => Icons.play_circle_outline_rounded,
                    ResourceType.cbtTechnique => Icons.psychology_alt_outlined,
                  };
                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() => _tab = t);
                        _load();
                      },
                      child: Column(
                        children: [
                          Icon(
                            icon,
                            color: selected ? AppColors.lavenderDeep : AppColors.textTertiary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: selected ? AppColors.lavenderDeep : AppColors.textTertiary,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
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
                child: Text('Recommended for You', style: theme.textTheme.titleMedium),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final item = _items[i];
                        return SoftCard(
                          onTap: () => context.push('/toolkit/item/${item.id}'),
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 64,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.lavenderSoft,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  _tab == ResourceType.video
                                      ? Icons.play_arrow_rounded
                                      : Icons.menu_book_rounded,
                                  color: AppColors.lavenderDeep,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title, style: theme.textTheme.titleSmall),
                                    if (item.author != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        item.author!,
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: AppColors.lavenderDeep,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 4),
                                    Text(
                                      item.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.lavenderSoft,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _tabLabel.replaceAll(' Techniques', ''),
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: AppColors.lavenderDeep,
                                        ),
                                      ),
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
