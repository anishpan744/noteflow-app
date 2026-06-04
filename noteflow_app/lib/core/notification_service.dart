import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../models/task.dart';

/// Local-notification scheduling + FCM foreground display.
/// Android channel: `noteflow_tasks`.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'noteflow_tasks';
  static const String _channelName = 'Task Reminders';
  static const String _channelDesc =
      'Reminders and alerts for your scheduled tasks';

  // Up to this many notifications per task (due time + reminder offsets).
  static const int _maxSlotsPerTask = 8;

  bool _initialized = false;

  // ── Init ─────────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialized || kIsWeb) return;
    _initialized = true;

    // Timezone setup (required for zonedSchedule)
    tzdata.initializeTimeZones();
    try {
      final localName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localName));
    } catch (_) {
      // Fall back to UTC if the device tz can't be resolved
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);

    // Create the Android channel
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.high,
      ),
    );

    await requestPermissions();
  }

  Future<void> requestPermissions() async {
    if (kIsWeb) return;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
  }

  // ── Details ────────────────────────────────────────────────────────────────

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
      );

  // ── Scheduling ───────────────────────────────────────────────────────────

  int _baseId(String taskId) => taskId.hashCode & 0x7fffffff;

  /// Schedules the due-time alert plus any pre-task reminders for [task].
  /// Reminder offsets are minutes-before-due, taken from `task.reminders`.
  Future<void> scheduleTaskReminder(Task task) async {
    if (kIsWeb || task.dueDate == null) return;
    await cancelTaskReminder(task.id);

    final due = _combineDateAndTime(task.dueDate!, task.dueTime);
    final now = DateTime.now();
    final base = _baseId(task.id);

    // Slot 0 = due time; slots 1..N = reminder offsets
    final triggers = <DateTime>[due];
    for (final minutes in task.reminders) {
      triggers.add(due.subtract(Duration(minutes: minutes)));
    }

    var slot = 0;
    for (final trigger in triggers) {
      if (slot >= _maxSlotsPerTask) break;
      if (trigger.isAfter(now)) {
        final body = slot == 0
            ? (task.dueTime != null ? 'Due now at ${task.dueTime}' : 'Due today')
            : 'Upcoming task';
        await _plugin.zonedSchedule(
          base + slot,
          task.title.isEmpty ? 'Task reminder' : task.title,
          body,
          tz.TZDateTime.from(trigger, tz.local),
          _details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: task.id,
        );
      }
      slot++;
    }
  }

  Future<void> cancelTaskReminder(String taskId) async {
    if (kIsWeb) return;
    final base = _baseId(taskId);
    for (var i = 0; i < _maxSlotsPerTask; i++) {
      await _plugin.cancel(base + i);
    }
  }

  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }

  // ── Immediate display (used by FCM foreground) ──────────────────────────────

  Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb) return;
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      _details,
      payload: payload,
    );
  }

  Future<void> handleFCMMessage(RemoteMessage message) async {
    final n = message.notification;
    if (n == null) return;
    await show(
      title: n.title ?? 'NoteFlow',
      body: n.body ?? '',
      payload: message.data['route'] as String?,
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  DateTime _combineDateAndTime(DateTime date, String? hhmm) {
    if (hhmm == null) {
      return DateTime(date.year, date.month, date.day, 9, 0);
    }
    final parts = hhmm.split(':');
    final h = int.tryParse(parts[0]) ?? 9;
    final m = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    return DateTime(date.year, date.month, date.day, h, m);
  }
}
