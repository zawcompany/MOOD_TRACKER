import 'package:flutter/material.dart';
import '../../domain/mood_model.dart';

class DashboardProvider extends ChangeNotifier {

  /// Dummy untuk sekarang (nanti tinggal ganti pakai Firestore)
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
}
