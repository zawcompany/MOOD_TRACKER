import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
// FIX: Path import relatif ke DashboardProvider
import '../provider/dashboard_provider.dart'; 
// FIX: Path import relatif ke MoodModel
import '../../domain/mood_model.dart'; 

class WeeklyMoodRow extends StatelessWidget {
  const WeeklyMoodRow({super.key}); 
  
  @override
  Widget build(BuildContext context) {
    // Consumer mendengarkan perubahan pada DashboardProvider
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        final weeklyMoods = dashboardProvider.weeklyMoods; 
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weeklyMoods.map((mood) => MoodIcon(
            day: mood.day,
            iconAssetPath: mood.iconAssetPath, 
            key: ValueKey(mood.day), 
          )).toList(),
        );
      },
    );
  }
}

class MoodIcon extends StatelessWidget {
  final String day;
  final String iconAssetPath;
  
  const MoodIcon({required this.day, required this.iconAssetPath, super.key}); 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Menggunakan Image.asset untuk karakter mood
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(iconAssetPath, height: 40, width: 40, fit: BoxFit.cover,
            // Fallback jika file gambar tidak ditemukan
            errorBuilder: (context, error, stackTrace) => Container(
              height: 40, width: 40, 
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(15)),
              child: const Icon(Icons.mood, color: Colors.purple),
            ),
          ), 
        ),
        const SizedBox(height: 4),
        Text(day, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}