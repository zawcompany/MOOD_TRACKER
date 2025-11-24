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

  // emotion options per mood label
  Map<String, List<String>> options = {
    "Bad": ["Anxious", "Frustrated", "Gloomy", "Irritable", "Lonely"],
    "Fine": ["Calm", "Content", "Neutral", "Relaxed", "Stable"],
    "Wonderful": ["Excited", "Joyful", "Enthusiastic", "Beloved", "Euphoric"],
  };

  Color? overrideBgColor; // BG khusus untuk detail mood

  @override
  void initState() {
    super.initState();
    overrideBgColor = widget.bgColor.withOpacity(0.25); // BG ringan
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> emotionOptions =
        options[widget.label] ?? <String>["Neutral"];

    return Scaffold(
      backgroundColor: overrideBgColor, // Background detail TIDAK ikut choose mood
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back, size: 26),
                    ),
                  ),
                  const SizedBox(width: 8),
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

              // Monster Image
              Image.asset(widget.imagePath, height: 120),

              const SizedBox(height: 12),

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

              // ⚡ EMOTION CHIPS (warna mengikuti mood)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: emotionOptions.map((e) {
                  final selected = _selectedEmotions.contains(e);

                  return ChoiceChip(
                    label: Text(
                      e,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    selected: selected,

                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedEmotions.add(e);

                          // ubah background agar lebih lembut saat memilih
                          overrideBgColor = widget.bgColor.withOpacity(0.18);
                        } else {
                          _selectedEmotions.remove(e);
                          if (_selectedEmotions.isEmpty) {
                            overrideBgColor = widget.bgColor.withOpacity(0.25);
                          }
                        }
                      });
                    },

                    // WARNA FOLLOW MOOD
                    backgroundColor: Colors.white,
                    selectedColor: widget.bgColor,

                    // HOVER / PRESSED EFFECT
                    pressElevation: 0,
                    shadowColor: widget.bgColor.withOpacity(0.25),
                    selectedShadowColor: widget.bgColor.withOpacity(0.4),

                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 18),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Want to add a note?",
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
              ),

              const SizedBox(height: 8),

              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

              // SAVE BUTTON
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
                  child:
                      const Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSave() {
    final Map<String, dynamic> result = {
      "mood": widget.label,
      "emotions": _selectedEmotions.toList(),
      "note": _noteController.text.trim(),
      "image": widget.imagePath,
    };

    Navigator.pop(context, result);
  }
}
