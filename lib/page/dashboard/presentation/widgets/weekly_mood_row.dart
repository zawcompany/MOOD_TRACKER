import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../services/mood_service.dart';

class WeeklyMoodRow extends StatelessWidget {
  final List<MoodEntryModel> moods;

  const WeeklyMoodRow({super.key, required this.moods});

  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.startsWith('0X')) {
      hexColor = hexColor.substring(2);
    }
    if (hexColor.length == 8) {
      return Color(int.parse(hexColor, radix: 16));
    }
    return Colors.grey;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final Map<DateTime, MoodEntryModel> moodMap = {};

    for (var m in moods) {
      final dateKey =
          DateTime(m.timestamp.year, m.timestamp.month, m.timestamp.day);
      if (moodMap.containsKey(dateKey)) {
        final existingMood = moodMap[dateKey]!;
        if (m.timestamp.isAfter(existingMood.timestamp)) {
          moodMap[dateKey] = m;
        }
      } else {
        moodMap[dateKey] = m;
      }
    }
    
    // Logika untuk mengurutkan Mon-Sun (dari perubahan sebelumnya)
    final int weekday = now.weekday;
    final DateTime mondayOfCurrentWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: weekday - 1));

    final List<DateTime> last7Days = List.generate(7, (i) {
      return mondayOfCurrentWeek.add(Duration(days: i));
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final date = last7Days[i];
        final mood = moodMap[date];

        final color = mood != null
            ? _colorFromHex(mood.moodColorHex)
            : Colors.grey.shade300;

        String dayName = DateFormat('EEE').format(date);

        return Expanded(
          child: Column(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color,
                backgroundImage:
                    mood != null ? AssetImage(mood.imagePath) : null,
                child: mood == null
                    ? const Icon(Icons.remove,
                        color: Colors.white70, size: 20)
                    : null,
              ),
              const SizedBox(height: 4),
              Text(
                dayName,
                style: TextStyle(
                  fontWeight:
                      _isSameDay(date, now) ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}