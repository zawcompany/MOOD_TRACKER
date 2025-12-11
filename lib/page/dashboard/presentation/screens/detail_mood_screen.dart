import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../services/mood_service.dart';

Color hexToColor(String hexColor) {
  final hexCode = hexColor.replaceAll('0x', '').replaceAll('#', '');
  try {
    final cleanedHex = hexCode.length == 8 ? hexCode : 'FF$hexCode';
    return Color(int.parse(cleanedHex, radix: 16));
  } catch (e) {
    return Colors.black;
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
              stream:
                  _moodService.getMoodsForMonth(_selectedYear, _selectedMonth),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 260,
                    child: Center(child: CircularProgressIndicator()),
                  );
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
                return SizedBox(height: 260, child: _calendar(moodsForMonth));
              },
            ),
            const SizedBox(height: 20),
            Expanded(child: _noteBox()),
          ],
        ),
      ),
    );
  }

  // MONTH SELECTOR 
  Widget _monthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _changeMonth(_focusedDay.month - 1),
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          "${_monthName(_selectedMonth)} $_selectedYear",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => _changeMonth(_focusedDay.month + 1),
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

  // CALENDAR
  Widget _calendar(List<MoodEntryModel> moodsForMonth) {
    final days = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);

    final Map<int, MoodEntryModel> dailyMoodsMap = {};

    // ambil mood terakhir per hari
    for (var mood in moodsForMonth) {
      dailyMoodsMap[mood.timestamp.day] = mood;
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

        final isSelected = date.year == _selectedDay.year &&
            date.month == _selectedDay.month &&
            date.day == _selectedDay.day;

        final dailyMoodEntry = dailyMoodsMap[date.day];
        final hasMood = dailyMoodEntry != null;

        final color = hasMood
            ? hexToColor(dailyMoodEntry!.moodColorHex)
            : Colors.grey.shade300;

        return GestureDetector(
          onTap: () => setState(() => _selectedDay = date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.25)
                  : (hasMood ? color.withValues(alpha: 0.10) : Colors.white),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasMood ? color : Colors.grey.shade400,
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

  // NOTES 
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

        final entries = snapshot.data ?? [];

        if (entries.isEmpty) return _emptyNotesBox();

        final descriptions = {
          "Bad": "Gloomy",
          "Fine": "Calm",
          "Wonderful": "Cheerful",
        };

        return ListView.separated(
          padding: const EdgeInsets.all(4),
          itemCount: entries.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final entry = entries[index];
            final color = hexToColor(entry.moodColorHex);

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // top row: mood label + delete button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${entry.moodLabel} – ${descriptions[entry.moodLabel] ?? ''}",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),

                      // DELETE BUTTON
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        color: Colors.red,
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: const Text("Delete Note"),
                              content: const Text(
                                  "Are you sure you want to delete this mood note?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(c, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(c, true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await _moodService.deleteMood(entry.id);
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(entry.note, style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 4),

                  Text(
                    DateFormat("HH:mm").format(entry.timestamp),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _emptyNotesBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Text(
        "No mood notes for this date.",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
