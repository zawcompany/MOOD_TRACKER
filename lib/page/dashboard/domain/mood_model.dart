// lib/page/dashboard/domain/mood_model.dart

class MoodModel {
  final String day; // Mon, Tue, etc.
  final String moodType; // Wonderful, Sad, etc.
  final String iconAssetPath; // Path ke gambar karakter di assets/

  MoodModel({
    required this.day,
    required this.moodType,
    required this.iconAssetPath,
  });
}