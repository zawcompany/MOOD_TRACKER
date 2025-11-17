// lib/page/dashboard/presentation/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
// PERBAIKAN: Path import relatif ke widgets
import '../widgets/weekly_mood_row.dart';
import '../widgets/quote_card.dart'; 

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(24, 60, 24, 24),
        // Tambahkan gradien sesuai desain Anda
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50.withOpacity(0.5), Colors.pink.shade50.withOpacity(0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hey, iLa', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),

            // Weekly Mood
            Text('Your Weekly Mood', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: 16),
            Center(child: WeeklyMoodRow()), 
            SizedBox(height: 40),

            // Quote of the Day
            Text('Quote of the Day', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: 16),
            QuoteCard(), 
            Spacer(),

            // Lihat Mood Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigasi ke Halaman Detail Mood
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: Text('Lihat Mood', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}