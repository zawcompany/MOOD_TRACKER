import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final Map<int, MoodEntryModel?> moodMap = {};
    for (int i = 1; i <= 7; i++) {
      moodMap[i] = null;
    }

    for (var m in moods) {
      moodMap[m.timestamp.weekday] = m;
    }

    const dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final mood = moodMap[i + 1];
        final color = mood != null
            ? _colorFromHex(mood.moodColorHex)
            : Colors.grey.shade300;

        return Column(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color,
              backgroundImage:
                  mood != null ? AssetImage(mood.imagePath) : null,
              child: mood == null
                  ? const Icon(Icons.remove, color: Colors.white70, size: 20)
                  : null,
            ),
            const SizedBox(height: 4),
            Text(dayNames[i]),
          ],
        );
      }),
    );
  }
}
