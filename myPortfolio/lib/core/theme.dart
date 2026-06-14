import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Light
  static const lightBg      = Color(0xFFEFEBE2);
  static const lightSurface = Color(0xFFF5F2EB);
  static const lightBorder  = Color(0xFFD4CEBD);
  static const lightText    = Color(0xFF0F0F0F);
  static const lightMuted   = Color(0xFF6B6760);
  static const lightAccent  = Color(0xFF2C6B5E);
  // Dark
  static const darkBg       = Color(0xFF141414);
  static const darkSurface  = Color(0xFF1E1E1E);
  static const darkBorder   = Color(0xFF2E2E2E);
  static const darkText     = Color(0xFFF0EDE6);
  static const darkMuted    = Color(0xFF8A8580);
  static const darkAccent   = Color(0xFF3BAFA0);
  // Shared
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
}

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class AppTheme {
  static Color bgColor(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
          ? AppColors.darkBg : AppColors.lightBg;

  static Color surfaceColor(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
          ? AppColors.darkSurface : AppColors.lightSurface;

  static Color borderColor(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
          ? AppColors.darkBorder : AppColors.lightBorder;

  static Color textColor(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
          ? AppColors.darkText : AppColors.lightText;

  static Color mutedColor(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
          ? AppColors.darkMuted : AppColors.lightMuted;

  static Color accentColor(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
          ? AppColors.darkAccent : AppColors.lightAccent;

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark()  => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark  = brightness == Brightness.dark;
    final bg      = isDark ? AppColors.darkBg      : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface  : AppColors.lightSurface;
    final text    = isDark ? AppColors.darkText     : AppColors.lightText;
    final accent  = isDark ? AppColors.darkAccent   : AppColors.lightAccent;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: accent,
        onPrimary: isDark ? AppColors.black : AppColors.white,
        secondary: accent,
        onSecondary: isDark ? AppColors.black : AppColors.white,
        surface: surface,
        onSurface: text,
        error: const Color(0xFFE53935),
        onError: AppColors.white,
      ),
      dividerColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ).apply(bodyColor: text, displayColor: text),
      iconTheme: IconThemeData(color: text),
    );
  }
}