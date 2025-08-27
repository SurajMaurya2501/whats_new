import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings(
          '@mipmap/whats_new_icon_playstore',
        ),
      ),
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );
  }

  Future<void> showNotification({
    required String title,
    required String description,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          '0',
          title,
          channelDescription: description,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      description,
      notificationDetails,
      payload: 'item x',
    );
  }

  void scheduleDailyNotifications({
    required String title,
    required String description,
    required List<TimeOfDay> times,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    for (var i = 0; i < times.length; i++) {
      final time = times[i];
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        i, // unique id for each notification
        title,
        description,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_notification_channel',
            'Daily Notifications',
            channelDescription: 'Channel for daily notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }
}
