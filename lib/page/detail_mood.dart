import 'package:flutter/material.dart';
import '../../services/mood_service.dart'; 
import 'custom_navbar_screen.dart'; 

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
  final Set<String> _selectedEmotions = {};
  final TextEditingController _noteController = TextEditingController();
  final MoodService _moodService = MoodService();

  bool _isLoading = false;

  Map<String, List<String>> options = {
    "Bad": ["Anxious", "Frustrated", "Gloomy", "Irritable", "Lonely"],
    "Fine": ["Calm", "Content", "Neutral", "Relaxed", "Stable"],
    "Wonderful": ["Excited", "Joyful", "Enthusiastic", "Beloved", "Euphoric"],
  };

  Color? backgroundColor;

  Color paleBackground(Color base) {
    return Color.lerp(Colors.white, base, 0.08)!;
  }

  @override
  void initState() {
    super.initState();
    backgroundColor = paleBackground(widget.bgColor);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _toggleEmotionSelection(String emotion, bool selected) {
    if (!mounted) return;
    setState(() {
      if (selected) {
        _selectedEmotions.add(emotion);

        backgroundColor = Color.lerp(Colors.white, widget.bgColor, 0.15)!;
      } else {
        _selectedEmotions.remove(emotion);
        backgroundColor = paleBackground(widget.bgColor);
      }
    });
  }

  void _onSave() async {
    final BuildContext currentContext = context;

    if (_selectedEmotions.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(content: Text('Anda harus memilih setidaknya satu emosi.')),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    final note = _noteController.text.trim();
    
    final moodColorHex = '0x${widget.bgColor.value.toRadixString(16).toUpperCase()}';
    
    final emotionsString = _selectedEmotions.join(', ');

    try {
      await _moodService.saveMoodEntry(
        moodLabel: widget.label,
        imagePath: widget.imagePath,
        moodColorHex: moodColorHex,
        note: "$note [Emotions: $emotionsString]",
      );

      if (!mounted) return;
      
      // navigasi ke navbar utama setelah berhasil
      Navigator.of(currentContext).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const CustomNavbarScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(content: Text('gagal menyimpan mood: ${e.toString().replaceFirst('Exception: ', '')}')),
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> emotionOptions = options[widget.label] ?? ["Neutral"];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
    
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [

                // header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Image.asset(widget.imagePath, height: 120),

                const SizedBox(height: 16),

                const Text(
                  "what best describes\nthis mood?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "select at least one emotion",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),

                const SizedBox(height: 16),

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
                      onSelected: (val) => _toggleEmotionSelection(e, val),
                      backgroundColor: Colors.white,
                      selectedColor: widget.bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // note section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "want to add a note?",
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  height: 120,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _noteController,
                    expands: true,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "write a few words if you want",
                    ),
                  ),
                ),

                const SizedBox(height: 24), 

                // save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                        : const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}