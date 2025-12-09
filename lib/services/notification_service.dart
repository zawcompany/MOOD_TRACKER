import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart'; 

// Handler untuk pesan yang diterima saat aplikasi di background/terminated
// HARUS top-level function (di luar kelas)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Inisialisasi Firebase harus dilakukan di sini juga jika app benar-benar tertutup
  await Firebase.initializeApp(); 
  print('Handling a background message: ${message.messageId}');
  // Ini memenuhi requirement "Notif Boleh trigger notif secara manual"
}

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  
  // Channel untuk Android (Wajib)
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', 
    'Notifikasi Penting', // Nama channel yang muncul di setting HP
    description: 'Channel ini digunakan untuk notifikasi penting.', 
    importance: Importance.max,
  );

  Future<void> initNotifications() async {
    // 1. Setup Izin Notifikasi
    await _firebaseMessaging.requestPermission();
    
    // 2. Tentukan handler background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 3. Setup Local Notification Plugin (untuk menampilkan notif saat app Foreground)
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _localNotifications.initialize(initializationSettings);

    // 4. Buat Channel untuk Android
    final androidImplementation = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(_androidChannel);
    }
    
    // 5. Handle Foreground Messages (Notifikasi Tampil Langsung)
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
        );
      }
    });

    // 6. Dapatkan Token FCM (PENTING: untuk mengirim notifikasi ke user spesifik)
    final token = await _firebaseMessaging.getToken();
    print('FCM Token: $token'); 
    // TODO: Wajib TA: Simpan token ini ke database/Firestore Anda
  }
}