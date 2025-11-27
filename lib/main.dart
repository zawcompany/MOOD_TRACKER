import 'package:flutter/material.dart';
import 'package:mood_tracker/page/profile_page.dart';
import 'package:provider/provider.dart';

// Import Dashboard Provider & Screen
import 'page/dashboard/presentation/provider/dashboard_provider.dart';
import 'page/dashboard/presentation/screens/dashboard_screen.dart';

// Import halaman lain
import 'page/sign_in_page.dart';
import 'page/welcome_page.dart';



// TODO: Tambahkan Firebase jika diperlukan
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Tambahkan init Firebase jika dibutuhkan
  // await Firebase.initializeApp();

  runApp(const MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider Dashboard
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mood Tracker',
        theme: ThemeData(
          fontFamily: 'Quicksand',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8C64D8),
          ),
          useMaterial3: true,
        ),

        // NOTE:
      // Saat testing → DashboardScreen
        // Saat deploy → WelcomePage
        home: const ProfilePage(),
        // Kalau mau ganti ke WelcomePage:
        // home: const WelcomePage(),
      ),
    );
  }
}
