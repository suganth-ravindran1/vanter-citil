import 'package:flutter/material.dart';

/// FreeMind AI palette — white base with soft lavender / blue accents.
abstract final class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAFAFC);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color lavender = Color(0xFF9B8AC4);
  static const Color lavenderDeep = Color(0xFF7B6BA8);
  static const Color lavenderSoft = Color(0xFFEDE8F5);
  static const Color lavenderMist = Color(0xFFF5F2FA);
  static const Color orbGlow = Color(0xFFB8A9D6);

  static const Color softBlue = Color(0xFF8BA3C7);
  static const Color softBlueLight = Color(0xFFE8EEF6);

  static const Color sage = Color(0xFF5A8F6B);
  static const Color sageDeep = Color(0xFF3D6B4A);
  static const Color sageSoft = Color(0xFFE8F3EB);
  static const Color sageMist = Color(0xFFF2F8F4);

  static const Color textPrimary = Color(0xFF1A1A1E);
  static const Color textSecondary = Color(0xFF6B6B76);
  static const Color textTertiary = Color(0xFF9A9AA6);
  static const Color divider = Color(0xFFE8E8EE);

  static const Color sleepPurple = Color(0xFF8B7EC8);
  static const Color sleepBlue = Color(0xFFA8C5E2);
  static const Color sleepGreen = Color(0xFFB8D4C8);
  static const Color sleepYellow = Color(0xFFE8D9A8);

  static const Color danger = Color(0xFFC45C5C);
  static const Color success = Color(0xFF5A8F6B);

  static const LinearGradient journalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5B8A9A), Color(0xFF8FB9A8)],
  );

  static const LinearGradient mindBodyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8F3EB), Color(0xFFD4E8D8)],
  );

  static const LinearGradient resourcesGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF0EBF8), Color(0xFFE0D6F0)],
  );

  static const LinearGradient mountainGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x00EDE8F5),
      Color(0x66C8B8E0),
      Color(0x99A890C8),
    ],
  );
}
