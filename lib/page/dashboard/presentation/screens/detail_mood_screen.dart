import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/dashboard_provider.dart';

class DetailMoodScreen extends StatelessWidget {
  const DetailMoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Mood Detail")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _monthSelector(provider),
            const SizedBox(height: 20),
            _calendar(provider),
            const SizedBox(height: 20),
            _noteBox(provider),
          ],
        ),
      ),
    );
  }

  Widget _monthSelector(DashboardProvider p) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: const Icon(Icons.arrow_left),
            onPressed: () => p.changeMonth(p.selectedMonth - 1)),
        Text(
          "${_monthName(p.selectedMonth)} ${p.selectedYear}",
          style: const TextStyle(fontSize: 20),
        ),
        IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: () => p.changeMonth(p.selectedMonth + 1)),
      ],
    );
  }

  String _monthName(int m) {
    const months = [
      "",
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[m];
  }

  Widget _calendar(DashboardProvider p) {
    final days = DateUtils.getDaysInMonth(p.selectedYear, p.selectedMonth);

    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8),
        itemCount: days,
        itemBuilder: (context, i) {
          final date = DateTime(p.selectedYear, p.selectedMonth, i + 1);
          final isSelected = date.day == p.selectedDate.day &&
              date.month == p.selectedMonth;

          final hasMood = p.monthlyMood.any((m) => m.date.day == date.day);

          return GestureDetector(
            onTap: () => p.selectDate(date),
            child: Container(
              decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.greenAccent
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: hasMood ? Colors.green : Colors.grey)),
              child: Center(
                child: Text("${i + 1}"),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _noteBox(DashboardProvider p) {
    final mood = p.getNoteForSelectedDate();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey.shade200),
      child: Text(
        mood?.note ?? "Tidak ada catatan",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
