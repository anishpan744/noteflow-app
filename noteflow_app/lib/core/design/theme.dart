import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tokens.dart';
import 'typography.dart';

// ── ThemeNotifier ─────────────────────────────────────────────────────────────

const _kThemePrefKey = 'theme_mode';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadSaved();
    return ThemeMode.dark;
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kThemePrefKey);
    if (saved != null) {
      state = ThemeMode.values.firstWhere(
        (m) => m.name == saved,
        orElse: () => ThemeMode.dark,
      );
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemePrefKey, mode.name);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

// ── Dark theme ────────────────────────────────────────────────────────────────

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: kBg0,
  colorScheme: ColorScheme.dark(
    primary: kNeon,
    secondary: kViolet,
    tertiary: kTeal,
    error: kCrimson,
    surface: kBg1,
    onPrimary: kBg0,
    onSecondary: kBg0,
    onSurface: kTextPrimary,
    onError: kTextPrimary,
  ),
  textTheme: buildTextTheme(),
  cardTheme: const CardThemeData(
    elevation: 0,
    color: Colors.transparent,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: kBg0,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleTextStyle: buildTextTheme().headlineMedium,
    iconTheme: const IconThemeData(color: kTextPrimary),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: kBg1,
    selectedItemColor: kNeon,
    unselectedItemColor: kTextMuted,
    elevation: 0,
    type: BottomNavigationBarType.fixed,
  ),
  navigationRailTheme: const NavigationRailThemeData(
    backgroundColor: kBg1,
    selectedIconTheme: IconThemeData(color: kNeon),
    unselectedIconTheme: IconThemeData(color: kTextMuted),
    selectedLabelTextStyle: TextStyle(color: kNeon),
    indicatorColor: kGlowBlue,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kBg2,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kGlassBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kGlassBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kNeon, width: 1.5),
    ),
    hintStyle: const TextStyle(color: kTextMuted),
  ),
  dividerTheme: const DividerThemeData(color: kGlassBorder, thickness: 1),
  iconTheme: const IconThemeData(color: kTextSecondary),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kNeon,
    foregroundColor: kBg0,
    elevation: 0,
  ),
  useMaterial3: true,
);

// ── Light theme (arctic) ──────────────────────────────────────────────────────

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: kLightBg0,
  colorScheme: ColorScheme.light(
    primary: kNeonLight,
    secondary: kViolet,
    tertiary: kTeal,
    error: kCrimson,
    surface: kLightBg1,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: kLightTextPrimary,
    onError: Colors.white,
  ),
  textTheme: buildTextTheme(light: true),
  cardTheme: const CardThemeData(elevation: 0, color: Colors.transparent),
  appBarTheme: AppBarTheme(
    backgroundColor: kLightBg0,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleTextStyle: buildTextTheme(light: true).headlineMedium,
    iconTheme: const IconThemeData(color: kLightTextPrimary),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: kLightBg1,
    selectedItemColor: kNeonLight,
    unselectedItemColor: kLightTextMuted,
    elevation: 0,
    type: BottomNavigationBarType.fixed,
  ),
  navigationRailTheme: NavigationRailThemeData(
    backgroundColor: kLightBg1,
    selectedIconTheme: const IconThemeData(color: kNeonLight),
    unselectedIconTheme: IconThemeData(color: kLightTextMuted),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kLightBg2,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: kLightTextMuted.withValues(alpha: 0.3)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: kLightTextMuted.withValues(alpha: 0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kNeonLight, width: 1.5),
    ),
    hintStyle: TextStyle(color: kLightTextMuted),
  ),
  dividerTheme: DividerThemeData(
    color: kLightTextMuted.withValues(alpha: 0.2),
    thickness: 1,
  ),
  iconTheme: IconThemeData(color: kLightTextSecondary),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kNeonLight,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  useMaterial3: true,
);
