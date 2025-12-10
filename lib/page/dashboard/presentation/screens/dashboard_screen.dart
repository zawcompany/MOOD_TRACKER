import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../services/auth_service.dart';
import '../../../../services/mood_service.dart';

import '../widgets/weekly_mood_row.dart';
import '../widgets/quote_card.dart';

import 'detail_mood_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final MoodService _moodService = MoodService();
  final AuthService _authService = AuthService();

  final Color _purpleAccent = const Color(0xFF8C64D8);
  final Color _lightPurpleBorder = const Color(0xFFB8AEE0);

  final Map<String, String> _moodImagePaths = const {
    "Bad": "assets/images/bad.png",
    "Fine": "assets/images/fine.png",
    "Wonderful": "assets/images/wonderful.png",
  };

  Widget _buildSuggestedActivity(MoodEntryModel? latestMood, MoodService moodService) {
    final String latestMoodLabel = latestMood?.moodLabel ?? "Fine";
    final randomSuggestion = moodService.getRandomPrescription(latestMoodLabel);
    final String imagePath = _moodImagePaths[latestMoodLabel] ?? "assets/images/fine.png";
    final Color headerColor = latestMood != null 
        ? Color(int.parse(latestMood.moodColorHex.substring(2), radix: 16)) 
        : Colors.grey.shade700;

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24), 
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _lightPurpleBorder, width: 2.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER DAN GAMBAR ANIMASI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded( 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daily Mood Prescription:", 
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: headerColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // mood info
                      Text(
                        "you are feeling: ${latestMoodLabel}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 10), 

                Image.asset(
                  imagePath,
                  height: 50, 
                  width: 50,
                ),
              ],
            ),
            
            const Divider(height: 20),

            Text(
              randomSuggestion,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // streambuilder untuk nama pengguna
                StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.userChanges(),
                  builder: (context, authSnapshot) {
                    if (authSnapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        "Hey, Loading...",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }

                    if (authSnapshot.data == null) {
                      return const Text(
                        "Hey, Pengguna",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }

                    return FutureBuilder<ProfileData>(
                      future: _authService.fetchProfileData(),
                      builder: (context, profileSnapshot) {
                        String userName = 'Pengguna';

                        if (profileSnapshot.connectionState ==
                                ConnectionState.done &&
                            profileSnapshot.hasData) {
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                // streambuilder untuk weekly mood
                StreamBuilder<List<MoodEntryModel>>(
                  stream: _moodService.getWeeklyMoodStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('error memuat data: ${snapshot.error}'),
                      );
                    }

                    final moods = snapshot.data ?? [];

                    if (moods.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'belum ada entri mood dalam 7 hari terakhir.',
                        ),
                      );
                    }

                    return WeeklyMoodRow(moods: moods);
                  },
                ),

                const SizedBox(height: 30),

                const Text(
                  "Quote of the Day",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const QuoteCard(),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailMoodScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Mood Details"),
                ),

                const SizedBox(height: 30), 
                
                StreamBuilder<MoodEntryModel?>(
                  stream: _moodService.getLatestMoodEntry(),
                  builder: (context, latestMoodSnapshot) {
                      final latestMood = latestMoodSnapshot.data;
                      return _buildSuggestedActivity(latestMood, _moodService);
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}