class MoodModel {
  final String id;
  final DateTime date;
  final String mood; 
  final String note;

  MoodModel({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
  });

  factory MoodModel.fromMap(String id, Map<String, dynamic> data) {
    return MoodModel(
      id: id,
      date: DateTime.parse(data['date']),
      mood: data['mood'],
      note: data['note'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "date": date.toIso8601String(),
      "mood": mood,
      "note": note,
    };
  }
}
