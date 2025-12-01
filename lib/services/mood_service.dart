import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodEntryModel {
  final String id;
  final String moodLabel;
  final String note;
  final String imagePath;
  final String moodColorHex;
  final DateTime timestamp;

  MoodEntryModel({
    required this.id,
    required this.moodLabel,
    required this.note,
    required this.imagePath,
    required this.moodColorHex,
    required this.timestamp,
  });

  factory MoodEntryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MoodEntryModel(
      id: doc.id,
      moodLabel: data['moodLabel'] ?? 'Unknown',
      note: data['note'] ?? '',
      imagePath: data['imagePath'] ?? '',
      moodColorHex: data['moodColor'] ?? '0xFF000000',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}

class MoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMoodEntry({
    required String moodLabel,
    required String note,
    required String imagePath,
    required String moodColorHex,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User is not logged in.");
    }

    try {
      await _firestore.collection('mood_entries').add({
        'userId': user.uid,
        'moodLabel': moodLabel,
        'note': note,
        'imagePath': imagePath,
        'moodColor': moodColorHex,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to save mood entry: $e');
    }
  }

  Stream<List<MoodEntryModel>> getWeeklyMoodStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty(); 
    }

    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    return _firestore
        .collection('mood_entries')
        .where('userId', isEqualTo: user.uid) 
        .where('timestamp', isGreaterThanOrEqualTo: sevenDaysAgo) 
        .orderBy('timestamp', descending: true) 
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MoodEntryModel.fromFirestore(doc)).toList();
    });
  }

  Stream<List<MoodEntryModel>> getMoodsForDay(DateTime day) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty(); 
    }

    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(const Duration(days: 1)); 

    return _firestore
        .collection('mood_entries')
        .where('userId', isEqualTo: user.uid)
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThan: endOfDay) 
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) => MoodEntryModel.fromFirestore(doc)).toList();
    });
  }
}