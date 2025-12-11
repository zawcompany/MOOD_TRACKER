import 'package:flutter/material.dart';
import 'detail_mood.dart';

class ChooseMoodPage extends StatefulWidget {
  final String userName;

  const ChooseMoodPage({super.key, required this.userName});

  @override
  State<ChooseMoodPage> createState() => _ChooseMoodPageState();
}

class _ChooseMoodPageState extends State<ChooseMoodPage> {
  double sliderValue = 0; 

  @override
  Widget build(BuildContext context) {
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
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 28, color: Colors.grey[700]),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Hey, ${widget.userName}! How are you\nfeeling right now?",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 40),

              Image.asset(
                mood["image"] as String,
                height: 150,
              ),

              const SizedBox(height: 20),

              Text(
                mood["label"] as String,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: mood["color"] as Color,
                ),
              ),

              const SizedBox(height: 20),

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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final currentContext = context; 
                    
                    final result = await Navigator.push(
                      currentContext,
                      MaterialPageRoute(
                        builder: (context) => DetailMoodPage(
                          label: mood['label'] as String,
                          bgColor: mood['color'] as Color,
                          imagePath: mood['image'] as String,
                        ),
                      ),
                    );

                    if (!currentContext.mounted) return;
                    
                    if (result == true) { 
                      
                      Navigator.pushNamedAndRemoveUntil(
                          currentContext, "/dashboard", (route) => false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
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