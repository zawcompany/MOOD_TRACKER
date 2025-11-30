import 'package:flutter/material.dart';
import '../../domain/mood_model.dart';

class WeeklyMoodRow extends StatelessWidget {
  final List<MoodModel> moods;

  const WeeklyMoodRow({super.key, required this.moods});

  @override
  Widget build(BuildContext context) {
    final Map<int, MoodModel?> byDay = {};

    for (int i = 1; i <= 7; i++) {
      byDay[i] = null;
    }

    for (final m in moods) {
      byDay[m.date.weekday] = m;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final day = i + 1;
        final mood = byDay[day];

        return Column(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade300,
              child: mood == null
                  ? const Icon(Icons.remove, color: Colors.grey)
                  : Text(mood.mood),
            ),
            const SizedBox(height: 4),
            Text(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][i]),
          ],
        );
      }),
    );
  }
}