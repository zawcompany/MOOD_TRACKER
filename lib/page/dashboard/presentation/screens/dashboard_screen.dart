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
  
  // warna ungu pekat untuk tombol mood details
  final Color _purpleAccent = const Color(0xFF8C64D8);
  
  // warna ungu muda untuk border (lebih soft)
  final Color _lightPurpleBorder = const Color(0xFFB8AEE0);

  // map untuk menghubungkan mood label dengan image asset path
  final Map<String, String> _moodImagePaths = const {
    "Bad": "assets/images/bad.png",
    "Fine": "assets/images/fine.png",
    "Wonderful": "assets/images/wonderful.png",
  };

  // helper widget untuk membangun saran aktivitas harian
  Widget _buildSuggestedActivity(MoodEntryModel? latestMood, MoodService moodService) {
    // tentukan mood label, default ke "Fine" jika belum ada data
    final String latestMoodLabel = latestMood?.moodLabel ?? "Fine";
    
    // mengambil saran secara acak dari service
    final randomSuggestion = moodService.getRandomPrescription(latestMoodLabel);
    
    // ambil path gambar monster
    final String imagePath = _moodImagePaths[latestMoodLabel] ?? "assets/images/fine.png";

    // tentukan warna header berdasarkan mood terakhir atau default abu-abu
    final Color headerColor = latestMood != null 
        ? Color(int.parse(latestMood.moodColorHex.substring(2), radix: 16)) 
        : Colors.grey.shade700;

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Container(
        // menambah padding vertikal (atas/bawah) menjadi 24
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24), 
        decoration: BoxDecoration(
          color: Colors.white, // background putih untuk kontras
          borderRadius: BorderRadius.circular(12),
          // menggunakan warna ungu muda untuk border stroke
          border: Border.all(color: _lightPurpleBorder, width: 2.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER DAN GAMBAR MONSTER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // kolom untuk teks (header dan mood info)
                Expanded( 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // header
                      Text(
                        "Daily Mood Prescription:", // terjemahan baru
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: headerColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // mood info
                      Text(
                        "you are feeling: ${latestMoodLabel}", // terjemahan baru
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 10), 

                // gambar monster (kanan)
                Image.asset(
                  imagePath,
                  height: 50, 
                  width: 50,
                ),
              ],
            ),
            
            const Divider(height: 20),
            
            // 2. saran teks
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

                // mood details button (atas)
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

                // saran aktivitas (bawah)
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