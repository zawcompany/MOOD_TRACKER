import 'package:flutter/material.dart';
import '../../domain/mood_model.dart';

class WeeklyMoodRow extends StatelessWidget {
  final List<MoodModel> moods;

  const WeeklyMoodRow({super.key, required this.moods});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: moods.map((mood) {
        return Column(
          children: [
            CircleAvatar(
              radius: 22,
              child: Text(mood.mood),
            ),
            const SizedBox(height: 4),
            Text(
              ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"][mood.date.weekday - 1]
            ),
          ],
        );
      }).toList(),
    );
  }
}
