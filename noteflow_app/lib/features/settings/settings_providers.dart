import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/design/tokens.dart';

// ── Text size ─────────────────────────────────────────────────────────────────

enum AppTextSize { small, medium, large, extraLarge }

extension AppTextSizeX on AppTextSize {
  double get scale => switch (this) {
        AppTextSize.small      => 0.85,
        AppTextSize.medium     => 1.0,
        AppTextSize.large      => 1.15,
        AppTextSize.extraLarge => 1.3,
      };

  String get label => switch (this) {
        AppTextSize.small      => 'S',
        AppTextSize.medium     => 'M',
        AppTextSize.large      => 'L',
        AppTextSize.extraLarge => 'XL',
      };
}

const _kTextSizeKey = 'text_size';

class TextSizeNotifier extends Notifier<AppTextSize> {
  @override
  AppTextSize build() {
    _load();
    return AppTextSize.medium;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kTextSizeKey);
    if (saved != null) {
      state = AppTextSize.values.firstWhere(
        (s) => s.name == saved,
        orElse: () => AppTextSize.medium,
      );
    }
  }

  Future<void> set(AppTextSize size) async {
    state = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTextSizeKey, size.name);
  }
}

final textSizeProvider =
    NotifierProvider<TextSizeNotifier, AppTextSize>(TextSizeNotifier.new);

// ── Accent color ──────────────────────────────────────────────────────────────

const accentPresets = <Color>[kNeon, kViolet, kTeal, kAmber, kCrimson];

const _kAccentKey = 'accent_color';

class AccentNotifier extends Notifier<Color> {
  @override
  Color build() {
    _load();
    return kNeon;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_kAccentKey);
    if (saved != null) state = Color(saved);
  }

  Future<void> set(Color color) async {
    state = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kAccentKey, color.toARGB32());
  }
}

final accentColorProvider =
    NotifierProvider<AccentNotifier, Color>(AccentNotifier.new);

// ── App lock ──────────────────────────────────────────────────────────────────

const _kAppLockKey = 'app_lock_enabled';

class AppLockNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return false;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_kAppLockKey) ?? false;
  }

  Future<void> set(bool enabled) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAppLockKey, enabled);
  }
}

final appLockProvider =
    NotifierProvider<AppLockNotifier, bool>(AppLockNotifier.new);
