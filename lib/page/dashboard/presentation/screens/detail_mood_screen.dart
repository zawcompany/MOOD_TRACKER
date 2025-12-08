import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../services/mood_service.dart';

class DetailMoodScreen extends StatefulWidget {
  const DetailMoodScreen({super.key});

  @override
  State<DetailMoodScreen> createState() => _DetailMoodScreenState();
}

class _DetailMoodScreenState extends State<DetailMoodScreen> {
  final MoodService _moodService = MoodService();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  int get _selectedMonth => _focusedDay.month;
  int get _selectedYear => _focusedDay.year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mood History")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _monthSelector(),
            const SizedBox(height: 12),
            SizedBox(height: 260, child: _calendar()),
            const SizedBox(height: 20),
            Expanded(child: _noteBox()),
          ],
        ),
      ),
    );
  }

  Widget _monthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(
                _focusedDay.year,
                _focusedDay.month - 1,
                _focusedDay.day,
              );
            });
          },
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          "${_monthName(_selectedMonth)} $_selectedYear",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(
                _focusedDay.year,
                _focusedDay.month + 1,
                _focusedDay.day,
              );
            });
          },
          icon: const Icon(Icons.chevron_right),
        ),
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

  Widget _calendar() {
    final days = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: days,
      itemBuilder: (context, i) {
        final date = DateTime(_selectedYear, _selectedMonth, i + 1);
        final isSelected =
            date.day == _selectedDay.day && date.month == _selectedDay.month;

        final bool hasMood = false;
        Color moodColor = Colors.grey.shade300;

        return GestureDetector(
          onTap: () {
            setState(() => _selectedDay = date);
          },
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

  Widget _noteBox() {
    return StreamBuilder<List<MoodEntryModel>>(
      stream: _moodService.getMoodsForDay(_selectedDay),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final dailyEntries = snapshot.data ?? [];

        String combinedNotes = dailyEntries
            .map((e) =>
                "- ${e.moodLabel} (${DateFormat('HH:mm').format(e.timestamp)}):\n  ${e.note}\n")
            .join('\n');

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
              combinedNotes.isNotEmpty
                  ? "Catatan Tanggal ${DateFormat('d MMM').format(_selectedDay)}:\n\n$combinedNotes"
                  : "Tidak ada catatan mood pada tanggal ini.",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}