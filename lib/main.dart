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
  // TODO: Wajib: Tambahkan inisialisasi Firebase di sini:
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
        // Pastikan WelcomePage Anda sudah diimport
        home: const WelcomePage(),
      ),
    );
  }
}

// Catatan: WelcomePage dan SignInPage harus memanggil DashboardScreen setelah sukses login.
// Contoh navigasi di SignInPage:
/* Navigator.pushReplacement(
    context, 
    MaterialPageRoute(builder: (_) => DashboardScreen()),
  );
*/