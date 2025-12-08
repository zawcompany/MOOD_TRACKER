import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../services/auth_service.dart'; 
import '../../../../services/mood_service.dart';

import '../widgets/weekly_mood_row.dart';
import '../widgets/quote_card.dart';

class DashboardScreen extends StatelessWidget { 
  DashboardScreen({super.key});

  // Deklarasikan _authService dan _moodService sebagai final property
  final MoodService _moodService = MoodService();
  final AuthService _authService = AuthService(); 

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // STREAMBUILDER UNTUK NAMA PENGGUNA (Reaktif & Asinkron)
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, authSnapshot) {
                  if (authSnapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Hey, Loading...", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold));
                  }
                  
                  if (authSnapshot.data == null) {
                    return const Text("Hey, Pengguna", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold));
                  }

                  // FutureBuilder memanggil _authService yang sudah dideklarasikan di atas
                  return FutureBuilder<ProfileData>(
                    future: _authService.fetchProfileData(), 
                    builder: (context, profileSnapshot) {
                      String userName = 'Pengguna';
                      
                      if (profileSnapshot.connectionState == ConnectionState.done && profileSnapshot.hasData) {
                        userName = profileSnapshot.data!.fullName; 
                      } else if (authSnapshot.data?.displayName != null) {
                        userName = authSnapshot.data!.displayName!;
                      }
                      
                      return Text(
                        "Hey, ${userName.split(' ').first}",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Your Weekly Mood",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // STREAMBUILDER UNTUK WEEKLY MOOD (Reaktif ke Firestore)
              StreamBuilder<List<MoodEntryModel>>(
                stream: _moodService.getWeeklyMoodStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error memuat data: ${snapshot.error}'),
                    );
                  }

                  final moods = snapshot.data ?? [];

                  if (moods.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text('Belum ada entri mood dalam 7 hari terakhir.'),
                    );
                  }

                  return WeeklyMoodRow(moods: moods);
                },
              ),

              const SizedBox(height: 30),

              const Text(
                "Quote of the Day",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const QuoteCard(), 
              
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/detailMoodScreen");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C64D8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Lihat Mood"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}