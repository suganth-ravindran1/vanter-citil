import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/journal_entry.dart';

abstract class JournalRepository {
  Future<List<JournalEntry>> getEntries(String userId, {DateTime? day});
  Future<JournalEntry> addEntry(String userId, String content);
  Future<JournalEntry> generateAiReply(String userId, JournalEntry entry);
}

class JournalRepositoryImpl implements JournalRepository {
  JournalRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;
  static const _uuid = Uuid();

  String _key(String userId) => 'journals_$userId';

  Future<List<JournalEntry>> _all(String userId) async {
    final raw = _prefs.getString(_key(userId));
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => JournalEntry.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _save(String userId, List<JournalEntry> entries) async {
    await _prefs.setString(
      _key(userId),
      jsonEncode(entries.map((e) => e.toMap()).toList()),
    );
  }

  @override
  Future<List<JournalEntry>> getEntries(String userId, {DateTime? day}) async {
    final all = await _all(userId);
    if (day == null) return all;
    return all.where((e) {
      return e.createdAt.year == day.year &&
          e.createdAt.month == day.month &&
          e.createdAt.day == day.day;
    }).toList();
  }

  @override
  Future<JournalEntry> addEntry(String userId, String content) async {
    final entry = JournalEntry(
      id: _uuid.v4(),
      content: content.trim(),
      createdAt: DateTime.now(),
    );
    final all = await _all(userId);
    all.insert(0, entry);
    await _save(userId, all);
    return entry;
  }

  @override
  Future<JournalEntry> generateAiReply(String userId, JournalEntry entry) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final reply =
        'Thank you for writing this down. I notice care in your words. '
        'Whatever you shared today, you showed up for yourself — that matters. '
        'If one feeling stands out, give it a name and one kind next step.';
    final updated = entry.copyWith(aiReply: reply);
    final all = await _all(userId);
    final idx = all.indexWhere((e) => e.id == entry.id);
    if (idx >= 0) {
      all[idx] = updated;
      await _save(userId, all);
    }
    return updated;
  }
}
