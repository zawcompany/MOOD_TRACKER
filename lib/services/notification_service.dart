import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'dart:developer'; 

final _localNotifications = FlutterLocalNotificationsPlugin();

const _androidChannel = AndroidNotificationChannel(
  'high_importance_channel', 
  'Notifikasi Penting',
  description: 'Channel ini digunakan untuk notifikasi penting.', 
  importance: Importance.max,
);

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); 
  
  log('Handling a background message: ${message.messageId}', name: 'FCM Background'); 

  final notification = message.notification;
  if (notification != null) {
    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data['route'], 
    );
  }
}

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  
  void handleNotificationTap(NotificationResponse notificationResponse) {
    final payload = notificationResponse.payload;
    if (payload != null) {
      log('Notifikasi di-tap dengan payload: $payload', name: 'Notification Tap');
    }
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings(); 
    
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS, 
    );
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: handleNotificationTap,
    );

    final androidImplementation = _localNotifications.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(_androidChannel);
    }
    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: message.data['route'], 
        );
      }
    });

    getInitialMessage();

    final token = await _firebaseMessaging.getToken();
    log('FCM Token: $token', name: 'FCM Token'); 
  }
  
  Future<void> getInitialMessage() async {
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      final payload = initialMessage.data['route'];
      if (payload != null) {
        log('App dibuka dari notifikasi terminated dengan payload: $payload', name: 'Initial Message');
      }
    }
  }
}