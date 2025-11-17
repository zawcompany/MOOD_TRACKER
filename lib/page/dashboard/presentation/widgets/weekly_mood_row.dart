// lib/page/dashboard/presentation/widgets/weekly_mood_row.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// PERBAIKAN: Path import relatif ke DashboardProvider (naik 1 tingkat, lalu turun ke provider)
import '../provider/dashboard_provider.dart'; 

class WeeklyMoodRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk 'mendengarkan' perubahan di DashboardProvider
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        final weeklyMoods = dashboardProvider.weeklyMoods; // Data Reaktif
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weeklyMoods.map((mood) => MoodIcon(
            day: mood.day,
            iconAssetPath: mood.iconAssetPath, 
            moodType: mood.moodType,
          )).toList(),
        );
      },
    );
  }
}

class MoodIcon extends StatelessWidget {
  final String day;
  final String iconAssetPath;
  final String moodType;

  const MoodIcon({required this.day, required this.iconAssetPath, required this.moodType});

  @override
  Widget build(BuildContext context) {
    // Pastikan Anda sudah menambahkan gambar karakter di pubspec.yaml dan folder assets/
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(iconAssetPath, height: 40, width: 40, fit: BoxFit.cover), 
        ),
        SizedBox(height: 4),
        Text(day, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}