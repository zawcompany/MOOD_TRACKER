import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import Dashboard Provider & Screen
import 'dashboard/presentation/provider/dashboard_provider.dart';
import 'dashboard/presentation/screens/dashboard_screen.dart';

import 'sign_in_page.dart'; // Import teman Anda (diasumsikan ada di lib/page/)
import 'welcome_page.dart'; // Import teman Anda (diasumsikan ada di lib/page/)

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
        // Daftarkan Provider Dashboard
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        // TODO: Daftarkan provider lain (misal AuthProvider) di sini
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
        // Ganti kembali ke WelcomePage setelah testing selesai.
        home: const DashboardScreen(), 
      ),
    );
  }
}

// ... KODE WELCOME PAGE DAN SIGN IN PAGE TEMAN ANDA DISINI (HARUS AMAN DARI KONFLIK)