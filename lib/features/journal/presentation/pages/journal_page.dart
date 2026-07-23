import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/circle_icon_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/journal_entry.dart';
import '../../data/repositories/journal_repository_impl.dart';
import '../../../../core/di/injection.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  DateTime _selected = DateTime.now();
  List<JournalEntry> _entries = [];
  bool _loading = true;

  JournalRepositoryImpl get _repo => sl<JournalRepositoryImpl>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return;
    setState(() => _loading = true);
    final entries = await _repo.getEntries(user.id, day: _selected);
    if (!mounted) return;
    setState(() {
      _entries = entries;
      _loading = false;
    });
  }

  Future<void> _addJournal() async {
    final controller = TextEditingController();
    final content = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.viewInsetsOf(ctx).bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Journal',
                style: TextStyle(
                  fontFamily: 'Hanken Grotesk',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191C21),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your daily space to feel, reflect and grow.',
                style: TextStyle(
                  fontFamily: 'Hanken Grotesk',
                  fontSize: 15,
                  color: Color(0xFF414751),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 6,
                style: const TextStyle(fontFamily: 'Hanken Grotesk'),
                decoration: InputDecoration(
                  hintText: "What's on your mind today?",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFC1C7D3)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6D7A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => Navigator.pop(ctx, controller.text),
                  child: const Text('Save entry', style: TextStyle(fontFamily: 'Hanken Grotesk', fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (content == null || content.trim().isEmpty) return;
    if (!mounted) return;
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return;
    final entry = await _repo.addEntry(user.id, content);
    final withAi = await _repo.generateAiReply(user.id, entry);
    if (!mounted) return;
    setState(() {
      if (_isSameDay(withAi.createdAt, _selected)) {
        _entries = [withAi, ..._entries];
      }
    });
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('MMMM d, yyyy').format(_selected);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Top AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleIconButton(
                        icon: Icons.menu,
                        onPressed: () {},
                        backgroundColor: Colors.transparent,
                        shadow: false,
                        iconColor: const Color(0xFF005DA7),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'FreeMind AI',
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191C21),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x4DC1C7D3)),
                      image: const DecorationImage(
                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuA18UpUb9_NdobpIWTfE5RZOcJ44vO-yBcERtgDzkRwSD479zp44HgLLL7SYei0oLSo-oXPPCJS6__b5qYqBFT0HLn4RAmE4ZRY6VEGPKriayXxVTTn_u-LqRi4FBICwoOebi7MtTx9KzPZ-3B1wl6uX43RIYvQFKrZweZIiS3eYLslSPu8dM6NRlUuaqlHHWOi-K8-KoT_kYhno_XGTmlObBsY20mw5KvLP1lbx4XIrZXoPL6NvIA'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                children: [
                  // Journal Header Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'My Journal',
                                  style: TextStyle(
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF191C21),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.eco, color: Colors.teal[600]?.withOpacity(0.6)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Your daily space to feel, reflect and grow.',
                              style: TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                fontSize: 15,
                                color: Color(0xFF414751),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: _addJournal,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4A6D7A),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x33000000),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'ADD JOURNAL',
                            style: TextStyle(
                              fontFamily: 'Hanken Grotesk',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4A6D7A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Date Selector
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0x80F2F3FB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0x1AC1C7D3)),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, color: Color(0xFF414751)),
                          onPressed: () {
                            setState(() => _selected = _selected.subtract(const Duration(days: 1)));
                            _load();
                          },
                        ),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18, color: Color(0xFF414751)),
                            const SizedBox(width: 12),
                            Text(
                              dateLabel,
                              style: const TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF191C21),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF414751)),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, color: Color(0xFF414751)),
                          onPressed: () {
                            setState(() => _selected = _selected.add(const Duration(days: 1)));
                            _load();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 16),
                    child: Text(
                      'YOUR ENTRIES',
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF414751),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  
                  // Entries List
                  if (_loading)
                    const Center(child: CircularProgressIndicator())
                  else if (_entries.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'No entries for this day yet.',
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            color: Color(0xFF414751),
                          ),
                        ),
                      ),
                    )
                  else
                    ..._entries.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildEntryCard(e),
                        )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryCard(JournalEntry e) {
    return GestureDetector(
      onTap: () => _showDetail(e),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF456C7D),
              Color(0xFF608D96),
              Color(0xFF76A89C),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.jm().format(e.createdAt),
                  style: TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 1.1,
                  ),
                ),
                Text(
                  DateFormat('MMM d').format(e.createdAt),
                  style: TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    e.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Hanken Grotesk',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.6)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  e.hasAiReply ? 'AI Reply Available' : 'Generating AI Reply...',
                  style: const TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(JournalEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Journal entry',
                style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(fontFamily: 'Hanken Grotesk', fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(entry.content, style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(fontFamily: 'Hanken Grotesk')),
              if (entry.hasAiReply) ...[
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F0F7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: Color(0xFF6750A4), size: 18),
                          const SizedBox(width: 8),
                          Text('AI Reply', style: Theme.of(ctx).textTheme.titleSmall?.copyWith(fontFamily: 'Hanken Grotesk', fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(entry.aiReply!, style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(fontFamily: 'Hanken Grotesk')),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
