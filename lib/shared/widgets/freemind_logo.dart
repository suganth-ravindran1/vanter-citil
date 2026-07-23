import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Animated FreeMind logo: glowing orb + leaf mark + subtle mountain silhouette.
class FreeMindLogo extends StatefulWidget {
  const FreeMindLogo({
    super.key,
    this.size = 160,
    this.showMountains = true,
    this.animate = true,
  });

  final double size;
  final bool showMountains;
  final bool animate;

  @override
  State<FreeMindLogo> createState() => _FreeMindLogoState();
}

class _FreeMindLogoState extends State<FreeMindLogo>
    with TickerProviderStateMixin {
  late final AnimationController _pulse;
  late final AnimationController _rotate;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    _rotate = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );
    _scale = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
    _glow = Tween<double>(begin: 0.35, end: 0.7).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );

    if (widget.animate) {
      _pulse.repeat(reverse: true);
      _rotate.repeat();
    } else {
      _pulse.value = 0.5;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    _rotate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return SizedBox(
      width: size * 1.35,
      height: size * (widget.showMountains ? 1.45 : 1.2),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulse, _rotate]),
        builder: (context, _) {
          return CustomPaint(
            painter: _LogoPainter(
              scale: _scale.value,
              glow: _glow.value,
              rotation: _rotate.value * 2 * math.pi,
              showMountains: widget.showMountains,
            ),
            child: Center(
              child: Transform.scale(
                scale: _scale.value,
                child: Container(
                  width: size * 0.72,
                  height: size * 0.72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.orbGlow.withValues(alpha: 0.95),
                        AppColors.lavender.withValues(alpha: 0.85),
                        AppColors.lavenderDeep.withValues(alpha: 0.9),
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lavender.withValues(alpha: _glow.value),
                        blurRadius: 36,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.eco_rounded,
                    color: Colors.white.withValues(alpha: 0.95),
                    size: size * 0.32,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  _LogoPainter({
    required this.scale,
    required this.glow,
    required this.rotation,
    required this.showMountains,
  });

  final double scale;
  final double glow;
  final double rotation;
  final bool showMountains;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.42);

    // Soft sparkles
    final sparklePaint = Paint()
      ..color = AppColors.lavender.withValues(alpha: 0.35 + glow * 0.25)
      ..style = PaintingStyle.fill;
    for (var i = 0; i < 8; i++) {
      final angle = rotation + (i * math.pi / 4);
      final radius = size.width * 0.38;
      final p = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius * 0.85,
      );
      canvas.drawCircle(p, i.isEven ? 2.2 : 1.4, sparklePaint);
    }

    if (!showMountains) return;

    final mountainY = size.height * 0.72;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, mountainY + 20)
      ..lineTo(size.width * 0.18, mountainY - 8)
      ..lineTo(size.width * 0.35, mountainY + 18)
      ..lineTo(size.width * 0.52, mountainY - 28)
      ..lineTo(size.width * 0.68, mountainY + 10)
      ..lineTo(size.width * 0.82, mountainY - 6)
      ..lineTo(size.width, mountainY + 16)
      ..lineTo(size.width, size.height)
      ..close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.orbGlow.withValues(alpha: 0.35),
          AppColors.lavenderSoft.withValues(alpha: 0.55),
        ],
      ).createShader(Rect.fromLTWH(0, mountainY - 40, size.width, size.height));

    canvas.drawPath(path, paint);

    // Soft lake reflection strip
    final lake = Paint()
      ..color = AppColors.softBlue.withValues(alpha: 0.12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.15, size.height * 0.88, size.width * 0.7, 10),
        const Radius.circular(8),
      ),
      lake,
    );
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) =>
      oldDelegate.scale != scale ||
      oldDelegate.glow != glow ||
      oldDelegate.rotation != rotation;
}
