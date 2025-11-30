import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Provider
import 'page/dashboard/presentation/provider/dashboard_provider.dart';

// Screens Dashboard & Detail Mood
import 'page/dashboard/presentation/screens/dashboard_screen.dart';
import 'page/dashboard/presentation/screens/detail_mood_screen.dart';

// Halaman temanmu
import 'page/sign_in_page.dart';
import 'page/welcome_page.dart';
import 'page/profile_page.dart';

// TODO: Firebase jika diperlukan
// import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(const MoodTrackerApp());
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
        debugShowCheckedModeBanner: false,
        title: 'Mood Tracker',
        theme: ThemeData(
          fontFamily: 'Quicksand',
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF8C64D8),
          ),
          useMaterial3: true,
        ),

        // WAJIB memakai routing
        initialRoute: "/welcome",

        routes: {
          // Halaman lain
          "/welcome": (_) => const WelcomePage(),
          "/signIn": (_) => const SignInPage(),
          "/profile": (_) => const ProfilePage(),

          // Dashboard dan detail
          "/dashboard": (_) => const DashboardScreen(),
          "/detailMood": (_) => const DetailMoodScreen(),
        },
      ),
    );
  }
}
