// lib/services/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const List<String> moodReminders = [
    "Bagaimana kabarmu hari ini?",
    "Waktunya mencatat mood kamu!",
    "Satu menit untuk refleksi diri.",
    "Apa yang kamu rasakan sekarang?",
    "Jangan lupa cek emosi hari ini ya.",
  ];

  Future<void> initializeNotifications(
      Function(String?) onNavigateCallback) async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    tz.initializeTimeZones();

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        onNavigateCallback(details.payload);
      },
    );
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  Future<void> scheduleDailyMoodCheckin({String? message}) async {
    final String reminderMessage = message ?? moodReminders[0];

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 20, 0); 

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final androidDetails = AndroidNotificationDetails(
      'daily_checkin_channel_id',
      'Pengingat Mood Harian',
      channelDescription: 'Pengingat untuk mencatat mood harian',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await notificationsPlugin.zonedSchedule(
      0,
      'Mood Tracker',
      reminderMessage,
      scheduledDate, 
      notificationDetails,
      payload: 'NAV_TO_CHOOSE_MOOD',
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print("Pengingat mood harian berhasil dijadwalkan.");
  }
}