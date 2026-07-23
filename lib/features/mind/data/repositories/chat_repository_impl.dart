import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required ApiClient apiClient,
    required SharedPreferences prefs,
  })  : _api = apiClient,
        _prefs = prefs;

  final ApiClient _api;
  final SharedPreferences _prefs;
  static const _uuid = Uuid();

  String _historyKey(String userId) => 'chat_history_$userId';

  @override
  Future<List<ChatMessage>> getHistory(String userId) async {
    final raw = _prefs.getString(_historyKey(userId));
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => ChatMessage.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<void> saveMessage(String userId, ChatMessage message) async {
    final history = await getHistory(userId);
    history.add(message);
    final trimmed = history.length > 200 ? history.sublist(history.length - 200) : history;
    await _prefs.setString(
      _historyKey(userId),
      jsonEncode(trimmed.map((m) => m.toMap()).toList()),
    );
  }

  @override
  Future<void> clearHistory(String userId) async {
    await _prefs.remove(_historyKey(userId));
  }

  @override
  Stream<String> streamReply({
    required String userId,
    required String message,
    required AiMode mode,
    required String language,
    required bool usePersonalization,
    required List<ChatMessage> history,
  }) async* {
    try {
      final response = await _api.dio.post<ResponseBody>(
        '/api/v1/chat/stream',
        data: {
          'user_id': userId,
          'message': message,
          'mode': mode.name,
          'language': language,
          'use_personalization': usePersonalization,
          'history': history.take(20).map((m) => m.toMap()).toList(),
        },
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: const Duration(seconds: 90),
        ),
      );

      final stream = response.data?.stream;
      if (stream == null) {
        yield* _localStream(message, mode, language);
        return;
      }

      var buffer = '';
      await for (final chunk in stream.cast<List<int>>()) {
        buffer += utf8.decode(chunk, allowMalformed: true);
        final parts = buffer.split('\n');
        buffer = parts.removeLast();
        for (final line in parts) {
          final trimmed = line.trim();
          if (trimmed.startsWith('data:')) {
            final payload = trimmed.substring(5).trim();
            if (payload == '[DONE]') return;
            try {
              final json = jsonDecode(payload) as Map<String, dynamic>;
              final token = json['token'] as String? ?? '';
              if (token.isNotEmpty) yield token;
            } catch (_) {
              if (payload.isNotEmpty) yield payload;
            }
          }
        }
      }
    } catch (_) {
      yield* _localStream(message, mode, language);
    }
  }

  Stream<String> _localStream(String message, AiMode mode, String language) async* {
    final reply = _craftLocalReply(message, mode, language);
    for (final word in reply.split(' ')) {
      yield '$word ';
      await Future<void>.delayed(const Duration(milliseconds: 28));
    }
  }

  String _craftLocalReply(String message, AiMode mode, String language) {
    final lower = message.toLowerCase();
    final base = switch (mode) {
      AiMode.reframeThought =>
        'Thank you for sharing that thought. Let\'s gently reframe it. '
            'What feels most true right now is worth noticing — and what might be a story your mind is adding? '
            'A kinder alternative could be: "I\'m having a hard moment, and I can take one small step." '
            'What small step feels possible today?',
      AiMode.situationSolver =>
        'I hear you. Let\'s look at this situation together. '
            '1) Name what is in your control. 2) Choose one next action that is kind and concrete. '
            '3) Give yourself permission to pause if emotions run high. '
            'What part of this would you like to unpack first?',
      AiMode.generalSupport =>
        'I\'m here with you. What you\'re feeling matters. '
            'Take a slow breath. You don\'t have to solve everything at once. '
            'Would you like space to vent, a gentle reframe, or help finding a next step?',
    };

    if (lower.contains('sleep') || lower.contains('tired')) {
      return 'Rest sounds important right now. A short wind-down — dim lights, a calm breath, and a kind thought before bed — can help. $base';
    }

    final langNote = language == 'English'
        ? ''
        : ' (I\'ll keep supporting you in $language as we continue.)';
    return '$base$langNote';
  }

  String newId() => _uuid.v4();
}
