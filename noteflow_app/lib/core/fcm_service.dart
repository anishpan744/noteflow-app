import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';

/// Top-level background message handler (must be a top-level / static function).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // On Android, FCM auto-displays messages that carry a `notification` payload
  // while the app is backgrounded, so no work is needed here. Data-only
  // messages could be handled here if required.
}

/// Registers the FCM token, requests permission, and wires foreground +
/// notification-tap handling.
class FCMService {
  FCMService._();
  static final FCMService instance = FCMService._();

  /// Called when a notification is tapped; receives an optional route string.
  void Function(String route)? onNavigate;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized || kIsWeb) return;
    _initialized = true;

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // Foreground messages → show via local notifications
    FirebaseMessaging.onMessage.listen((msg) {
      NotificationService.instance.handleFCMMessage(msg);
    });

    // App opened from a background notification tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpened);

    // App opened from a terminated state via notification tap
    final initial = await messaging.getInitialMessage();
    if (initial != null) _handleOpened(initial);
  }

  void _handleOpened(RemoteMessage message) {
    final route = message.data['route'] as String?;
    if (route != null && onNavigate != null) onNavigate!(route);
  }

  /// Saves the current device token under /users/{uid}/fcmTokens/{token}.
  Future<void> saveTokenForUser(String uid) async {
    if (kIsWeb) return;
    final messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    if (token != null) {
      await _writeToken(uid, token);
    }
    // Keep the stored token fresh on rotation
    messaging.onTokenRefresh.listen((t) => _writeToken(uid, t));
  }

  Future<void> _writeToken(String uid, String token) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('fcmTokens')
        .doc(token)
        .set({
      'token': token,
      'platform': _platformName,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  String get _platformName {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    return 'other';
  }
}
