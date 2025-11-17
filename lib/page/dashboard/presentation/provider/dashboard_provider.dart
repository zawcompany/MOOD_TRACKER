// lib/features/dashboard/presentation/provider/dashboard_provider.dart

import 'package:flutter/material.dart';
import 'package:lib/page/dashboard/domain/mood_model.dart';
// Ganti MOOD_TRACKER dengan nama project anda jika berbeda

class DashboardProvider extends ChangeNotifier {
  // --- STATE DATA ---
  
  // Data mood harian (disimulasikan sebagai data dari API/Backend)
  List<MoodModel> _weeklyMoods = [
    MoodModel(day: 'Mon', moodType: 'Wonderful', iconAssetPath: 'assets/mood_happy.png'),
    MoodModel(day: 'Tue', moodType: 'Fine', iconAssetPath: 'assets/mood_fine.png'),
    MoodModel(day: 'Wed', moodType: 'Bad', iconAssetPath: 'assets/mood_bad.png'),
    MoodModel(day: 'Thu', moodType: 'Fine', iconAssetPath: 'assets/mood_fine.png'),
    MoodModel(day: 'Fri', moodType: 'Wonderful', iconAssetPath: 'assets/mood_happy.png'),
    MoodModel(day: 'Sat', moodType: 'Chill', iconAssetPath: 'assets/mood_chill.png'),
    MoodModel(day: 'Sun', moodType: 'Chill', iconAssetPath: 'assets/mood_chill.png'),
  ];
  
  String _quoteOfTheDay = "Just one small positive thought in the morning can change your whole day.";

  // --- GETTERS ---
  List<MoodModel> get weeklyMoods => _weeklyMoods;
  String get quoteOfTheDay => _quoteOfTheDay;

  // --- LOGIC/ACTIONS ---
  
  // Fungsi ini nanti akan digunakan untuk menarik data dari API (Wajib)
  Future<void> fetchDashboardData() async {
    // Simulasi penarikan data dari backend
    await Future.delayed(Duration(seconds: 1)); 
    // Setelah data baru didapat, panggil:
    notifyListeners(); 
  }

  // Contoh fungsi yang memicu perubahan state (reaktif)
  void refreshQuote() {
    // TODO: Implementasi logika untuk mendapatkan quote baru
    _quoteOfTheDay = "A new day brings new strength and new thoughts.";
    // Memperbarui UI yang mendengarkan state ini
    notifyListeners(); 
  }
}