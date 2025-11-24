import 'package:flutter/material.dart';
import 'detail_mood.dart';

class ChooseMoodPage extends StatefulWidget {
  final String userName;

  const ChooseMoodPage({super.key, required this.userName});

  @override
  State<ChooseMoodPage> createState() => _ChooseMoodPageState();
}

class _ChooseMoodPageState extends State<ChooseMoodPage> {
  double sliderValue = 1; // default: Fine

  @override
  Widget build(BuildContext context) {
    // daftar mood
    final List<Map<String, Object>> moods = [
      {
        "label": "Bad",
        "color": Colors.redAccent,
        "image": "assets/images/bad.png",
      },
      {
        "label": "Fine",
        "color": Colors.teal,
        "image": "assets/images/fine.png",
      },
      {
        "label": "Wonderful",
        "color": Colors.amber,
        "image": "assets/images/wonderful.png",
      },
    ];

    final mood = moods[sliderValue.round()];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // tombol X
              Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.close, size: 28, color: Colors.grey[700]),
              ),

              const SizedBox(height: 20),

              // judul
              Text(
                "Hey, ${widget.userName}! How are you\nfeeling right now?",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 40),

              // emoji
              Image.asset(
                mood["image"] as String,
                height: 150,
              ),

              const SizedBox(height: 20),

              // label (Bad, Fine, Wonderful)
              Text(
                mood["label"] as String,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: mood["color"] as Color,
                ),
              ),

              const SizedBox(height: 20),

              // slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: mood["color"] as Color,
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: mood["color"] as Color,
                  overlayColor: (mood["color"] as Color).withOpacity(0.2),
                ),
                child: Slider(
                  min: 0,
                  max: 2,
                  divisions: 2,
                  value: sliderValue,
                  onChanged: (value) {
                    setState(() => sliderValue = value);
                  },
                ),
              ),

              const SizedBox(height: 8),
              const Text(
                "Slide to match how you're feeling",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),

              const Spacer(),

              // tombol continue
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailMoodPage(
                          label: mood['label'] as String,
                          bgColor: mood['color'] as Color,
                          imagePath: mood['image'] as String,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
