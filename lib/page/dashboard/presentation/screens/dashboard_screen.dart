import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/dashboard_provider.dart';
import '../widgets/weekly_mood_row.dart';
import '../widgets/quote_card.dart';
import 'package:mood_tracker/page/widgets/custom_navbar.dart';

// Import Choose Mood (jika bagianmu tidak handle input mood harian,
// kamu bisa hapus semua terkait choose mood)
import 'package:mood_tracker/page/choose_mood.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    const userName = "iLa"; // TODO: ganti dengan data user

    return Scaffold(
      bottomNavigationBar: CustomNavbar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) {
            Navigator.pushNamed(context, "/profile");
          }
        },
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hey, $userName",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
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

              WeeklyMoodRow(moods: provider.weeklyMood),

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
                  Navigator.pushNamed(context, "/detailMood");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C64D8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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