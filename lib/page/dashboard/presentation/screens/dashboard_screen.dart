import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../services/mood_service.dart';
import '../provider/dashboard_provider.dart';
import '../widgets/weekly_mood_row.dart';
import '../widgets/quote_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MoodService _moodService = MoodService();
  String _userName = 'Loading...'; // State awal

Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (mounted) {
      setState(() {
        _userName = user?.displayName ?? 'Pengguna';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hey, $_userName",
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
                        child:
                            Text('Belum ada entri mood dalam 7 hari terakhir.'),
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
      ),
    );
  }
}
