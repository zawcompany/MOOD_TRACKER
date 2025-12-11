import 'package:flutter/material.dart';
import '../../../../services/mood_service.dart'; 

class DashboardProvider extends ChangeNotifier {
  List<MoodEntryModel> weeklyMood = [];
  List<MoodEntryModel> monthlyMood = [];

  DateTime selectedDate = DateTime.now();
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  // data mood mingguan 
  void loadWeeklyMood(List<MoodEntryModel> moods) {
    weeklyMood = moods;
    notifyListeners();
  }

  // data mood bulanan 
  void loadMonthlyMood(List<MoodEntryModel> moods) {
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

  // catatan mood untuk tanggal yang sedang dipilih
  MoodEntryModel? getNoteForSelectedDate() {
    try {
      return monthlyMood.firstWhere(
        (m) =>
            m.timestamp.day == selectedDate.day &&
            m.timestamp.month == selectedMonth &&
            m.timestamp.year == selectedYear,
      );
    } catch (e) {
      return null;
    }
  }
}