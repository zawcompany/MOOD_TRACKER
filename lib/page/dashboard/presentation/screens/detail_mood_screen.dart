import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../services/mood_service.dart';

Color hexToColor(String hexColor) {
  final hexCode = hexColor.replaceAll('0x', '').replaceAll('#', '');
  try {
    // Menambahkan 'FF' di awal jika formatnya tanpa alpha (contoh: 8C64D8)
    final cleanedHex = hexCode.length == 8 ? hexCode : 'FF$hexCode'; 
    return Color(int.parse(cleanedHex, radix: 16));
  } catch (e) {
    return Colors.black; // Fallback ke warna hitam jika terjadi error
  }
}

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

  void _changeMonth(int newMonth) {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, newMonth, 1);
      _selectedDay = DateTime(_focusedDay.year, newMonth, 1);
    });
  }

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
            StreamBuilder<List<MoodEntryModel>>(
              stream: _moodService.getMoodsForMonth(_selectedYear, _selectedMonth), // Panggil service baru
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                      height: 260,
                      child: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasError) {
                  return SizedBox(
                    height: 260,
                    child: Center(
                      child: Text('Error memuat mood: ${snapshot.error}'),
                    ),
                  );
                }

                final moodsForMonth = snapshot.data ?? [];
                
                return SizedBox(
                  height: 260, 
                  child: _calendar(moodsForMonth),
                );
              },
            ),
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
            _changeMonth(_focusedDay.month - 1);
          },
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          "${_monthName(_selectedMonth)} $_selectedYear",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () {
            _changeMonth(_focusedDay.month - 1);
          },
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  String _monthName(int m) {
    const months = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[m];
  }

  Widget _calendar(List<MoodEntryModel> moodsForMonth) {
    final days = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);

    final Map<int, MoodEntryModel> dailyMoodsMap = {};
    for (var mood in moodsForMonth) {
      final day = mood.timestamp.day;
      if (!dailyMoodsMap.containsKey(day)) {
        dailyMoodsMap[day] = mood;
      }
    }

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
            date.day == _selectedDay.day && 
            date.month == _selectedDay.month &&
            date.year == _selectedDay.year;

        final dailyMoodEntry = dailyMoodsMap[date.day];
        final bool hasMood = false;

        Color moodColor = hasMood ? hexToColor(dailyMoodEntry!.moodColorHex) : Colors.grey.shade300;

        return GestureDetector(
          onTap: () {
            setState(() => _selectedDay = date);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? moodColor.withOpacity(0.3) : (hasMood ? moodColor.withOpacity(0.1) : Colors.white),
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
            .map(
              (e) =>
                  "- ${e.moodLabel} (${DateFormat('HH:mm').format(e.timestamp)}):\n  ${e.note}\n",
            )
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
                  ? "Notes for ${DateFormat('d MMM').format(_selectedDay)}:\n\n$combinedNotes"
                  : "No mood notes for this date.",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
