import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }
  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(String notificationMessage) async {
    await flutterLocalNotificationsPlugin.show(
        0,
        'Please plug your charger now!',
        notificationMessage,
        const NotificationDetails(
            android: AndroidNotificationDetails('0', 'applicationName',
                'To remind you about your battery level')),
        payload: 'data');
  }

  NotificationService._internal();
}
