import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Provider Dashboard
import 'page/dashboard/presentation/provider/dashboard_provider.dart';

// Screens
import 'page/dashboard/presentation/screens/dashboard_screen.dart';
import 'page/dashboard/presentation/screens/detail_mood_screen.dart';

// Pages 
import 'page/sign_in_page.dart';
import 'page/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

        // PENTING!
        initialRoute: "/dashboard",

        routes: {
          "/welcome": (_) => const WelcomePage(),
          "/signIn": (_) => const SignInPage(),
          "/dashboard": (_) => const DashboardScreen(),
          "/detailMood": (_) => const DetailMoodScreen(),
        },
      ),
    );
  }
}
