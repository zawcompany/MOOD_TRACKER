import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // [BARU] Diperlukan untuk mendapatkan username

// [BARU] Import untuk Notifikasi
import 'services/notification_service.dart';
import 'page/choose_mood.dart'; 
import 'firebase_options.dart';

import 'page/dashboard/presentation/provider/dashboard_provider.dart';
import 'page/dashboard/presentation/screens/dashboard_screen.dart';
import 'page/dashboard/presentation/screens/detail_mood_screen.dart';

import 'page/sign_in_page.dart';
import 'page/welcome_page.dart';
import 'page/profile_page.dart';
import 'page/forgot_password_page.dart';
import 'page/otp_verification_page.dart';
import 'page/reset_new_password_page.dart'; // Mengandung CreateNewPasswordPage (Diasumsikan)

// [BARU] 1. Global Key untuk Navigasi dari Notifikasi
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// [BARU] 2. Fungsi Callback Notifikasi
void onSelectNotification(String? payload) {
  if (payload == 'NAV_TO_CHOOSE_MOOD') {
    // Navigasi ke rute Choose Mood Page menggunakan Global Key
    navigatorKey.currentState?.pushNamed('/chooseMoodRoute'); 
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // [PERBAIKAN] 3. Inisialisasi dan Jadwal Notifikasi
    final notificationService = NotificationService();
    // Meneruskan fungsi callback untuk navigasi
    await notificationService.initializeNotifications(onSelectNotification); 
    
    // Opsional: Batalkan notif lama dan jadwalkan yang baru
    await notificationService.cancelAllNotifications(); 
    
    // Jadwalkan pengingat harian (misalnya, Jam 20:00 dengan pesan default pertama)
    await notificationService.scheduleDailyMoodCheckin(); 
    
    // [PERBAIKAN] 4. Run App
    runApp(const MoodTrackerApp());
    
  } catch (e) {
    print("Error initializing Firebase: $e");
    runApp(ErrorApp(errorMessage: e.toString()));
  }
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey, // [PERBAIKAN] Pasang Global Key ke MaterialApp
        debugShowCheckedModeBanner: false,
        title: 'Mood Tracker',
        theme: ThemeData(
          fontFamily: 'Quicksand',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8C64D8),
          ),
          useMaterial3: true,
        ),

        initialRoute: "/welcome",

        routes: {
          "/welcome": (_) => const WelcomePage(),
          "/signIn": (_) => const SignInPage(),
          "/profile": (_) => const ProfilePage(),

          "/dashboard": (_) => DashboardScreen(),
          "/detailMood": (_) => const DetailMoodScreen(),
          
          // [BARU] 5. Rute untuk Notifikasi (ChooseMoodPage)
          "/chooseMoodRoute": (context) {
             // Ambil username yang sedang login untuk halaman ChooseMoodPage
             final userName = FirebaseAuth.instance.currentUser?.displayName ?? 'Pengguna';
             return ChooseMoodPage(userName: userName);
          },

          "/forgotPassword": (_) => const ForgotPasswordPage(),
          "/otpVerification": (_) => const OtpVerificationPage(),
          // Diasumsikan CreateNewPasswordPage adalah nama kelas yang benar
          "/resetPassword": (_) => const CreateNewPasswordPage(),
        },
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String errorMessage;

  const ErrorApp({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Terjadi Kesalahan Fatal!",
                style: TextStyle(color: Colors.red, fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Gagal menghubungkan ke Firebase. Detail: $errorMessage",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
