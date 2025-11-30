class MoodModel {
  final DateTime date;
  final String mood;
  final List<String> emotions;
  final String note;
  final String imagePath;

  MoodModel({
    required this.date,
    required this.mood,
    required this.emotions,
    required this.note,
    required this.imagePath,
  });
}