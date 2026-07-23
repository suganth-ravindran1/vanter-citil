import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class SleepRecord extends Equatable {
  const SleepRecord({
    required this.id,
    required this.date,
    required this.durationMinutes,
    required this.bedtime,
    required this.wakeTime,
  });

  final String id;
  final DateTime date;
  final int durationMinutes;
  final String bedtime;
  final String wakeTime;

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'durationMinutes': durationMinutes,
        'bedtime': bedtime,
        'wakeTime': wakeTime,
      };

  factory SleepRecord.fromMap(Map<String, dynamic> map) => SleepRecord(
        id: map['id'] as String,
        date: DateTime.parse(map['date'] as String),
        durationMinutes: map['durationMinutes'] as int,
        bedtime: map['bedtime'] as String,
        wakeTime: map['wakeTime'] as String,
      );

  @override
  List<Object?> get props => [id, date, durationMinutes];
}

class SleepRepository {
  SleepRepository(this._prefs);
  final SharedPreferences _prefs;
  static const _uuid = Uuid();

  String _key(String userId) => 'sleep_$userId';

  Future<List<SleepRecord>> getRecords(String userId) async {
    final raw = _prefs.getString(_key(userId));
    if (raw == null) {
      // Seed last night sample
      final sample = SleepRecord(
        id: _uuid.v4(),
        date: DateTime.now().subtract(const Duration(days: 1)),
        durationMinutes: 438,
        bedtime: '11:35 PM',
        wakeTime: '6:53 AM',
      );
      await _prefs.setString(_key(userId), jsonEncode([sample.toMap()]));
      return [sample];
    }
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => SleepRecord.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> addRecord(String userId, SleepRecord record) async {
    final all = await getRecords(userId);
    all.insert(0, record);
    await _prefs.setString(_key(userId), jsonEncode(all.map((e) => e.toMap()).toList()));
  }
}

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  SleepRecord? _last;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return;
    final records = await sl<SleepRepository>().getRecords(user.id);
    if (!mounted) return;
    setState(() => _last = records.isNotEmpty ? records.first : null);
  }

  String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final last = _last;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
          children: [
            // Top Status Bar Area
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Sleep Recovery',
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191C21),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.nightlight_round, color: Colors.blue[700]),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Rest well. Wake better.',
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 15,
                        color: Color(0xFF414751),
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
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none, color: Color(0xFF414751)),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Sleep Tracker Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0x33C1C7D3)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.indigo[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.show_chart, color: Colors.indigo[500]),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sleep Tracker',
                              style: TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF191C21),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Track your sleep and understand your patterns.',
                              style: TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                fontSize: 12,
                                color: Color(0xFF414751),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Last Night',
                            style: TextStyle(
                              fontFamily: 'Hanken Grotesk',
                              fontSize: 12,
                              color: Color(0xFF414751),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            last == null ? '—' : _formatDuration(last.durationMinutes),
                            style: const TextStyle(
                              fontFamily: 'Hanken Grotesk',
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF191C21),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 96,
                        width: 140, // about half of the remaining space
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            0.2, 0.4, 0.6, 0.45, 0.25, 0.5, 0.35, 0.2, 0.75, 0.55, 0.3, 0.4
                          ].map((h) {
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                height: 96 * h,
                                decoration: BoxDecoration(
                                  color: Colors.indigo[(h > 0.6 ? 400 : h > 0.4 ? 300 : h > 0.25 ? 200 : 100)],
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: 140,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              last?.bedtime ?? '11:35 PM',
                              style: const TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                fontSize: 10,
                                color: Color(0xFF414751),
                              ),
                            ),
                            Text(
                              last?.wakeTime ?? '6:53 AM',
                              style: const TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                fontSize: 10,
                                color: Color(0xFF414751),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0x1AC1C7D3)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'View Progress',
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[600],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFF414751), size: 18),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Sleep Companion Section
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.spa, color: Colors.indigo[500], size: 20),
                ),
                const SizedBox(height: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sleep Companion',
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191C21),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Everything you need for a peaceful sleep.',
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 12,
                          color: Color(0xFF414751),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: const [
                _CompanionCard(
                  title: 'Sleep Stories',
                  subtitle: 'Calming stories to quiet your mind',
                  icon: Icons.auto_stories,
                  bgColor: Color(0x80EEF2FF), // indigo-50/50 approx
                  iconColor: Color(0xFF818CF8), // indigo-400
                ),
                _CompanionCard(
                  title: 'Sleep Methods',
                  subtitle: 'Proven techniques to fall asleep faster',
                  icon: Icons.dark_mode,
                  bgColor: Color(0x80EFF6FF), // blue-50/50 approx
                  iconColor: Color(0xFF93C5FD), // blue-300
                ),
                _CompanionCard(
                  title: 'Sleep Meditation',
                  subtitle: 'Guided meditations for deep relaxation',
                  icon: Icons.self_improvement,
                  bgColor: Color(0x80F0FDF4), // green-50/50 approx
                  iconColor: Color(0xFF22C55E), // green-500
                ),
                _CompanionCard(
                  title: 'Sounds',
                  subtitle: 'Soothing sounds for better sleep',
                  icon: Icons.music_note,
                  bgColor: Color(0x80FFF7ED), // orange-50/50 approx
                  iconColor: Color(0xFFFB923C), // orange-400
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanionCard extends StatelessWidget {
  const _CompanionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor, size: 32),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: const Icon(Icons.chevron_right, color: Color(0xFF414751), size: 18),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Hanken Grotesk',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF191C21),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Hanken Grotesk',
              fontSize: 11,
              color: Color(0xFF414751),
            ),
          ),
        ],
      ),
    );
  }
}
