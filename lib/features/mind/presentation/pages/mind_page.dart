import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/circle_icon_button.dart';
import '../../../../shared/widgets/freemind_logo.dart';
import '../../../../shared/widgets/orb_animation.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/chat_message.dart';
import '../bloc/mind_bloc.dart';

class MindPage extends StatefulWidget {
  const MindPage({super.key, this.onOpenDrawer});

  final VoidCallback? onOpenDrawer;

  @override
  State<MindPage> createState() => _MindPageState();
}

class _MindPageState extends State<MindPage> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final _speech = stt.SpeechToText();
  bool _listening = false;
  Timer? _affirmationTimer;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state.user;
    if (user != null) {
      context.read<MindBloc>().add(
            MindStarted(userId: user.id, language: user.language),
          );
    }
    _affirmationTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (mounted) {
        context.read<MindBloc>().add(const MindAffirmationTick());
      }
    });
  }

  @override
  void dispose() {
    _affirmationTimer?.cancel();
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _toggleVoice() async {
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    final available = await _speech.initialize();
    if (!available) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone unavailable on this device.')),
      );
      return;
    }
    setState(() => _listening = true);
    await _speech.listen(
      onResult: (result) {
        _controller.text = result.recognizedWords;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
        if (result.finalResult) {
          setState(() => _listening = false);
        }
      },
      listenOptions: stt.SpeechListenOptions(
        listenFor: const Duration(seconds: 20),
      ),
    );
  }

  void _send([String? prompt]) {
    final text = prompt ?? _controller.text;
    if (text.trim().isEmpty) return;
    final user = context.read<AuthBloc>().state.user;
    context.read<MindBloc>().add(
          MindSendMessage(
            text,
            usePersonalization: user?.aiConsent ?? false,
          ),
        );
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Action Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconButton(
                    icon: Icons.menu_rounded,
                    onPressed: widget.onOpenDrawer ?? () {},
                    backgroundColor: Colors.transparent,
                    shadow: false,
                    iconColor: const Color(0xFF44474E),
                  ),
                  Stack(
                    children: [
                      CircleIconButton(
                        icon: Icons.notifications_none_rounded,
                        onPressed: () {},
                        backgroundColor: Colors.transparent,
                        shadow: false,
                        iconColor: const Color(0xFF44474E),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A90E2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: BlocBuilder<MindBloc, MindState>(
                builder: (context, state) {
                  final hasChat = state.messages.isNotEmpty;
                  
                  return Stack(
                    children: [
                      ListView(
                        controller: _scroll,
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 160),
                        children: [
                          if (!hasChat) ...[
                            // Quote Section
                            const Center(
                              child: Icon(Icons.format_quote_rounded, color: Color(0x4D4A90E2), size: 32),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'You are allowed to slow down.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1C1E),
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Center(
                              child: Icon(Icons.favorite, color: Color(0x664A90E2), size: 16),
                            ),
                            const SizedBox(height: 48),
                            
                            // Central Orb
                            const Center(child: OrbAnimation()),
                            const SizedBox(height: 48),
                            
                            // Question Heading
                            const Text(
                              'How can I\nsupport you today?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1C1E),
                                height: 1.1,
                              ),
                            ),
                          ] else ...[
                             const SizedBox(height: 16),
                             ...state.messages.map(_MessageBubble.new),
                             if (state.isStreaming)
                               const Padding(
                                 padding: EdgeInsets.only(top: 8),
                                 child: Align(
                                   alignment: Alignment.centerLeft,
                                   child: _TypingDots(),
                                 ),
                               ),
                          ],
                        ],
                      ),
                      
                      // Floating Input Section
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: const Color(0x33C4C6D0)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0D000000),
                                  blurRadius: 30,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: _controller,
                                  minLines: 1,
                                  maxLines: 4,
                                  textInputAction: TextInputAction.send,
                                  onSubmitted: (_) => _send(),
                                  style: const TextStyle(fontSize: 15, fontFamily: 'Hanken Grotesk'),
                                  decoration: const InputDecoration(
                                    hintText: "Share what's on your mind...",
                                    hintStyle: TextStyle(color: Color(0x8044474E), fontSize: 15, fontFamily: 'Hanken Grotesk'),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: Icon(_listening ? Icons.mic : Icons.mic_none_rounded),
                                      color: _listening ? const Color(0xFF4A90E2) : const Color(0xFF44474E),
                                      onPressed: _toggleVoice,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF4A90E2),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x4D4A90E2),
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.send_rounded, color: Colors.white),
                                        onPressed: state.isStreaming ? null : () => _send(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _MessageBubble extends StatelessWidget {
  const _MessageBubble(this.message);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF4A90E2) : const Color(0xFFF2F0F7),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 6),
            bottomRight: Radius.circular(isUser ? 6 : 20),
          ),
        ),
        child: Text(
          message.content.isEmpty && message.isStreaming ? '…' : message.content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isUser ? Colors.white : const Color(0xFF1A1C1E),
                height: 1.45,
                fontFamily: 'Hanken Grotesk',
              ),
        ),
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_c.value + i * 0.2) % 1.0;
            final scale = 0.6 + (0.4 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0));
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 7 * scale,
              height: 7 * scale,
              decoration: const BoxDecoration(
                color: Color(0xFF4A90E2),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
