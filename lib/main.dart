import 'package:flutter/material.dart';
import 'package:mood_tracker/page/forgot_password_page.dart';
import 'package:mood_tracker/page/otp_verification_page.dart';
import '../../services/reset_new_password_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:mood_tracker/services/notification_service.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

import 'page/dashboard/presentation/provider/dashboard_provider.dart';
import 'page/dashboard/presentation/screens/dashboard_screen.dart';
import 'page/dashboard/presentation/screens/detail_mood_screen.dart';

import 'page/sign_in_page.dart';
import 'page/welcome_page.dart';
import 'page/profile_page.dart';

import 'dart:developer';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await NotificationService().initNotifications(); 

    runApp(const MoodTrackerApp());
    
  } catch (e) {
    log("Error initializing Firebase: $e", name: 'Firebase Init');
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
        debugShowCheckedModeBanner: false,
        title: 'Mood Tracker',
        theme: ThemeData(
          fontFamily: 'Quicksand',
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF8C64D8),
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

          "/forgotPassword": (_) => const ForgotPasswordPage(),
          "/otpVerification": (_) => const OtpVerificationPage(),
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