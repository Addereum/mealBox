import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:mealbox/l10n/generated/app_localizations.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (kIsWeb) return; // Notifications on web are not handled this way currently

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Berlin'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> requestPermissions() async {
    if (kIsWeb) return;
    
    try {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
    }

    try {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestExactAlarmsPermission();
    } catch (e) {
      debugPrint('Error requesting exact alarms permission: $e');
    }

    try {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (e) {
      debugPrint('Error requesting iOS permissions: $e');
    }
  }

  Future<void> scheduleMealReminders(AppLocalizations l10n) async {
    if (kIsWeb) return;
    await cancelAllNotifications(); // Clear existing ones first

    // Breakfast Reminder at 9:00 AM
    await _scheduleDailyReminder(
      id: 0,
      title: l10n.breakfastReminderTitle,
      body: l10n.breakfastReminderBody,
      hour: 9,
      minute: 0,
    );

    // Lunch Reminder at 1:00 PM
    await _scheduleDailyReminder(
      id: 1,
      title: l10n.lunchReminderTitle,
      body: l10n.lunchReminderBody,
      hour: 13,
      minute: 0,
    );

    // Dinner Reminder at 7:00 PM
    await _scheduleDailyReminder(
      id: 2,
      title: l10n.dinnerReminderTitle,
      body: l10n.dinnerReminderBody,
      hour: 19,
      minute: 0,
    );
  }

  Future<void> _scheduleDailyReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'mealbox_reminders',
          'Mahlzeiten Erinnerungen',
          channelDescription: 'Erinnert dich an regelmäßige Mahlzeiten',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> testNotification(AppLocalizations l10n) async {
    if (kIsWeb) return;
    await flutterLocalNotificationsPlugin.show(
      99,
      l10n.testNotificationTitle,
      l10n.testNotificationBody,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'mealbox_test',
          'Test Benachrichtigungen',
          channelDescription: 'Wird zum Testen der Benachrichtigungen verwendet',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> cancelReminder(int id) async {
    if (kIsWeb) return;
    await flutterLocalNotificationsPlugin.cancel(id);
    debugPrint('Abgebrochene Erinnerung mit ID: $id');
  }

  Future<void> cancelAllNotifications() async {
    if (kIsWeb) return;
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
