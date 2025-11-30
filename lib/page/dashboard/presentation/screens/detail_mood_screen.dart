import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/dashboard_provider.dart';
import '../../domain/mood_model.dart';

class DetailMoodScreen extends StatelessWidget {
  const DetailMoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DashboardProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Mood History")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _monthSelector(p),
            const SizedBox(height: 12),
            SizedBox(height: 260, child: _calendar(p)), // kalender lebih kecil
            const SizedBox(height: 20),
            Expanded(child: _noteBox(p)), // scrollable note
          ],
        ),
      ),
    );
  }

  // ================= MONTH SELECTOR =================

  Widget _monthSelector(DashboardProvider p) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () => p.changeMonth(p.selectedMonth - 1),
            icon: const Icon(Icons.chevron_left)),
        Text(
          "${_monthName(p.selectedMonth)} ${p.selectedYear}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
            onPressed: () => p.changeMonth(p.selectedMonth + 1),
            icon: const Icon(Icons.chevron_right)),
      ],
    );
  }

  String _monthName(int m) {
    const months = [
      "",
      "January","February","March","April","May","June",
      "July","August","September","October","November","December"
    ];
    return months[m];
  }

  // ================= CALENDAR =================

  Widget _calendar(DashboardProvider p) {
    final days = DateUtils.getDaysInMonth(p.selectedYear, p.selectedMonth);

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: days,
      itemBuilder: (context, i) {
        final date = DateTime(p.selectedYear, p.selectedMonth, i + 1);
        final isSelected = date.day == p.selectedDate.day;

        // Ambil mood berdasarkan tanggal
        MoodModel mood = p.monthlyMood.firstWhere(
          (m) =>
              m.date.year == date.year &&
              m.date.month == date.month &&
              m.date.day == date.day,
          orElse: () => MoodModel(
            date: date,
            mood: "",
            emotions: [],
            note: "",
            imagePath: "",
          ),
        );

        final bool hasMood = mood.mood.isNotEmpty;

        Color moodColor = Colors.grey.shade300;
        if (mood.mood == "Bad") moodColor = Colors.redAccent;
        if (mood.mood == "Fine") moodColor = Colors.teal;
        if (mood.mood == "Wonderful") moodColor = Colors.amber;

        return GestureDetector(
          onTap: () => p.selectDate(date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? moodColor.withOpacity(0.5) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasMood ? moodColor : Colors.grey.shade400,
                width: hasMood ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                "${i + 1}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: hasMood ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= NOTE BOX =================

  Widget _noteBox(DashboardProvider p) {
    final mood = p.getNoteForSelectedDate();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: SingleChildScrollView(
        child: Text(
          mood?.note.isNotEmpty == true
              ? mood!.note
              : "Tidak ada catatan",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}