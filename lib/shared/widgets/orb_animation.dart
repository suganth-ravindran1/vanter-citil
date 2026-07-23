import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class OrbAnimation extends StatefulWidget {
  const OrbAnimation({super.key});

  @override
  State<OrbAnimation> createState() => _OrbAnimationState();
}

class _OrbAnimationState extends State<OrbAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.7, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 288,
      height: 288,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF6750A4).withOpacity(0.4),
                          const Color(0xFF6750A4).withOpacity(0.1),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.4, 0.7],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color(0xFFA490FF),
                  Color(0xFF6750A4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6750A4).withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.eco,
                color: Colors.white,
                size: 96,
              ),
            ),
          ),
          const Positioned(
            top: 16,
            right: 16,
            child: Text('✦', style: TextStyle(color: Color(0x4D6750A4), fontSize: 24)),
          ),
          const Positioned(
            bottom: 40,
            left: 0,
            child: Text('✦', style: TextStyle(color: Color(0x336750A4), fontSize: 24)),
          ),
          const Positioned(
            top: 144,
            right: -16,
            child: Text('✦', style: TextStyle(color: Color(0x406750A4), fontSize: 24)),
          ),
        ],
      ),
    );
  }
}
