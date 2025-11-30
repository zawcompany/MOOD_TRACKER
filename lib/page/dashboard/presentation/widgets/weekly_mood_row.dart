import 'package:flutter/material.dart';
import '../../domain/mood_model.dart';

class WeeklyMoodRow extends StatelessWidget {
  final List<MoodModel> moods;

  const WeeklyMoodRow({super.key, required this.moods});

  @override
  Widget build(BuildContext context) {
    // Buat map: weekday (1–7) → MoodModel?
    final Map<int, MoodModel?> moodMap = {};
    for (int i = 1; i <= 7; i++) {
      moodMap[i] = null; // default kosong
    }

    // Isi dengan data actual mood minggu ini:
    for (var m in moods) {
      moodMap[m.date.weekday] = m;
    }

    const dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final mood = moodMap[i + 1];

        return Column(
          children: [
            // CircleAvatar berisi gambar atau icon kosong
            CircleAvatar(
              radius: 22,
              backgroundColor:
                  mood == null ? Colors.grey.shade300 : Colors.transparent,
              backgroundImage:
                  mood != null ? AssetImage(mood.imagePath) : null,
              child: mood == null
                  ? const Icon(Icons.remove, color: Colors.grey, size: 20)
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