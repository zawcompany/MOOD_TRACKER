import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import Dashboard Provider & Screen
import 'page/dashboard/presentation/provider/dashboard_provider.dart';
import 'page/dashboard/presentation/screens/dashboard_screen.dart';

import 'page/sign_in_page.dart'; 
import 'page/welcome_page.dart'; 

// TODO: Wajib: Tambahkan import Firebase di sini:
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Wajib: Tambahkan inisialisasi Firebase di sini!
  // await Firebase.initializeApp();
  
  runApp(const MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Membungkus MaterialApp dengan MultiProvider untuk State Management (Wajib TA)
    return MultiProvider(
      providers: [
        // Daftarkan Provider Dashboard untuk mengelola State
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        // TODO: Tambahkan provider lain (misal AuthProvider) di sini
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mood Tracker',
        theme: ThemeData(
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8C64D8)),
          useMaterial3: true,
        ),
        // GANTI home ke DashboardScreen untuk TESTING UI
        home: const DashboardScreen(), 
      ),
    );
  }
}

// --- KODE WELCOME PAGE DAN SIGNIN PAGE ANDA (DIPERTAHANKAN) ---
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8EFFF), Color(0xFFEDE5FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView( 
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/manyemoji.png',
                    width: width * 0.6, 
                  ),
                  SizedBox(height: height * 0.05),
                  Text(
                    "Not Sure About Your Mood?",
                    style: TextStyle(
                      fontSize: width * 0.055, 
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: height * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      // Navigasi ke SignInPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignInPage()), 
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.15,
                        vertical: height * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Let Us Help!",
                          style: TextStyle(fontSize: width * 0.04),
                        ),
                        SizedBox(width: width * 0.02),
                        Icon(Icons.arrow_forward, size: width * 0.045),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});
  @override
  Widget build(BuildContext context) {
    // Placeholder - Anda perlu membuat halaman sign in ini
    return const Scaffold(
      body: Center(child: Text("Halaman Sign In / Login Anda")),
    );
  }
}