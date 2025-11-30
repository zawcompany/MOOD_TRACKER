import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/dashboard_provider.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    // mood terakhir
    final String? mood = provider.lastMood;

    String quote = "Have a wonderful day!";
    String sub = "Every day is a new start.";

    if (mood != null && mood.isNotEmpty) {
      switch (mood) {
        case "Wonderful":
          quote = "You're glowing today! 🌟";
          sub = "Keep shining and spreading happiness.";
          break;
        case "Fine":
          quote = "One step at a time ❤️";
          sub = "It's okay to feel fine. You're doing great.";
          break;
        case "Bad":
          quote = "It's okay to not be okay 🖤";
          sub = "Be kind to yourself. Better days are coming.";
          break;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFE2FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quote,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}