import 'package:flutter/material.dart';
import '../../domain/mood_model.dart';

class DashboardProvider extends ChangeNotifier {
  List<MoodModel> weeklyMood = [];
  List<MoodModel> monthlyMood = [];

  DateTime selectedDate = DateTime.now();
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  void loadWeeklyMood(List<MoodModel> moods) {
    weeklyMood = moods;
    notifyListeners();
  }

  void loadMonthlyMood(List<MoodModel> moods) {
    monthlyMood = moods;
    notifyListeners();
  }

  void changeMonth(int newMonth) {
    selectedMonth = newMonth;
    notifyListeners();
  }

  void changeYear(int newYear) {
    selectedYear = newYear;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  MoodModel? getNoteForSelectedDate() {
    try {
      return monthlyMood.firstWhere(
        (m) =>
            m.date.day == selectedDate.day &&
            m.date.month == selectedMonth &&
            m.date.year == selectedYear,
      );
    } catch (e) {
      return null;
    }
  }

  /// --- BAGIAN BARU UNTUK SIMPAN MOOD HARI INI ---  
  String? lastMood;
  List<String>? lastEmotions;
  String? lastNote;
  String? lastImage;

  void setMood(Map<String, dynamic> data) {
    final mood = MoodModel(
      date: DateTime.now(),
      mood: data["mood"],
      emotions: List<String>.from(data["emotions"]),
      note: data["note"],
      imagePath: data["image"],
    );

    weeklyMood.add(mood);
    monthlyMood.add(mood);

    notifyListeners();
  }
}