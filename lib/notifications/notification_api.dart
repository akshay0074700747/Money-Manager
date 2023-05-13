import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:money_manager/hive/model_class.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService();

  init() async {
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    AndroidInitializationSettings androidInitializationSettings =
       const AndroidInitializationSettings("@mipmap/ic_launcher");



    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  getAndroidNotificationDetails() {
    // ignore: prefer_const_constructors
    return AndroidNotificationDetails(
      'reminder',
      'Reminder Notification',
      channelDescription: 'Notification sent as reminder',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      category: const AndroidNotificationCategory('reminder'),
      icon: "@mipmap/ic_launcher",
      groupKey: 'com.varadgauthankar.simple_reminder.REMINDER',
    );
  }


  getNotificationDetails() {
    return NotificationDetails(
      android: getAndroidNotificationDetails()
    );
  }

  Future scheduleNotification(futuretransactions reminder) async {
    // ignore: unnecessary_null_comparison
    if (reminder.transaction_date != null) {
      flutterLocalNotificationsPlugin.zonedSchedule(
        reminder.key,
        reminder.transaction_name,
        reminder.transaction_note,
        notificationTime(reminder.transaction_date),
        getNotificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
      // ignore: avoid_print
      print('notification set at ${reminder.transaction_date}');
    } else {
      return;
    }
  }

  Future<bool> reminderHasNotification(futuretransactions reminder) async {
    var pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications
        .any((notification) => notification.id == reminder.key);
  }

  void updateNotification(futuretransactions reminder) async {
    var hasNotification = await reminderHasNotification(reminder);
    if (hasNotification) {
      flutterLocalNotificationsPlugin.cancel(reminder.key);
    }

    scheduleNotification(reminder);
  }

  void cancelNotification(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
    // ignore: avoid_print
    print('$id canceled');
  }

  tz.TZDateTime notificationTime(DateTime dateTime) {
    return tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
  }
}

enum ReminderRepeat {
  never,
  daily,
  weekly,
  monthly,
  yearly,
}