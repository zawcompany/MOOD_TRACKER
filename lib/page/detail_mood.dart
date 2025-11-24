import 'package:flutter/material.dart';

class DetailMoodPage extends StatefulWidget {
  final String label;
  final Color bgColor;
  final String imagePath;

  const DetailMoodPage({
    super.key,
    required this.label,
    required this.bgColor,
    required this.imagePath,
  });

  @override
  State<DetailMoodPage> createState() => _DetailMoodPageState();
}

class _DetailMoodPageState extends State<DetailMoodPage> {
  // chips state
  final Set<String> _selectedEmotions = {};
  final TextEditingController _noteController = TextEditingController();

  // emotion options per mood label (sesuaikan bila ingin beda teks)
  Map<String, List<String>> options = {
    "Bad": ["Anxious", "Frustrated", "Gloomy", "Irritable", "Lonely"],
    "Fine": ["Calm", "Content", "Neutral", "Relaxed", "Stable"],
    "Wonderful": ["Excited", "Joyful", "Enthusiastic", "Beloved", "Euphoric"],
  };

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> emotionOptions =
        options[widget.label] ?? <String>["Neutral"];

    // UI uses a light background like the screenshot:
    return Scaffold(
      backgroundColor: widget.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // top bar (back + close)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // back
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back, size: 26),
                    ),
                  ),

                  // empty center placeholder so layout mirrors screenshot
                  const SizedBox(width: 8),

                  // close icon on right
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.close, size: 26),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // emoji image
              Image.asset(widget.imagePath, height: 120),

              const SizedBox(height: 12),

              // title
              Text(
                "What best describes\nthis mood?",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Select at least one emotion",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),

              const SizedBox(height: 14),

              // chips
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: emotionOptions.map((e) {
                    final selected = _selectedEmotions.contains(e);
                    return ChoiceChip(
                      label: Text(
                        e,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      selected: selected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _selectedEmotions.add(e);
                          } else {
                            _selectedEmotions.remove(e);
                          }
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 18),

              // note label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Want to add a note?",
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
              ),

              const SizedBox(height: 8),

              // note textfield (white card)
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  controller: _noteController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write a few words if you want",
                    hintStyle: TextStyle(color: Colors.black45),
                  ),
                ),
              ),

              const Spacer(),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSave() {
    // Build a result payload to send back to previous screen (if needed)
    final Map<String, dynamic> result = {
      "mood": widget.label,
      "emotions": _selectedEmotions.toList(),
      "note": _noteController.text.trim(),
      "image": widget.imagePath,
    };

    // For now: return result to previous screen and show Snackbar
    Navigator.pop(context, result);
  }
}