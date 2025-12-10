import 'dart:math'; 
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
  final Random _random = Random(); 

  // daftar saran aktivitas berdasarkan kategori mood
  final Map<String, List<String>> moodPrescriptions = {
    "Bad": [
      "try listening to your favorite music to distract your mind.", 
      // saran lebih umum
      "go for a walk around the nearest park or beach.", 
      "take 10 minutes to do some light stretching."
    ],
    "Fine": [
      "keep doing what you're doing! your mood is good today.",
      "try calling and having a casual chat with your friend.",
      // [FIX SINTAKS]: koma ditambahkan
      "give yourself time to enjoy a delicious tea or Matcha!."
    ],
    "Wonderful": [
      "use this energy to complete overdue tasks!",
      "spread your positive energy to people around you.",
      "try to remember the best thing that happened today and share it with others."
    ],
  };

  /// mengambil saran secara acak berdasarkan mood
  String getRandomPrescription(String moodLabel) {
    final suggestions = moodPrescriptions[moodLabel] ?? ["coba istirahat sebentar."];
    // pilih indeks acak
    final int randomIndex = _random.nextInt(suggestions.length);
    return suggestions[randomIndex];
  }

  /// menyimpan entri mood ke firestore
  Future<void> saveMoodEntry({
    required String moodLabel,
    required String note,
    required String imagePath,
    required String moodColorHex,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("user is not logged in.");

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
      throw Exception('failed to save mood entry: $e');
    }
  }

  /// menghapus entri mood
  Future<void> deleteMood(String id) async {
    try {
      await _firestore.collection('mood_entries').doc(id).delete();
    } catch (e) {
      throw Exception("failed to delete mood entry: $e");
    }
  }

  /// method mengambil mood terbaru (1 entry)
  Stream<MoodEntryModel?> getLatestMoodEntry() {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return const Stream.empty();

      // mengambil hanya 1 dokumen terbaru
      return _firestore
          .collection('mood_entries')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots()
          .map((snapshot) {
              if (snapshot.docs.isEmpty) {
                  return null;
              }
              return MoodEntryModel.fromFirestore(snapshot.docs.first);
          });
  }

  /// weekly stream: mengambil entri mood 7 hari terakhir
  Stream<List<MoodEntryModel>> getWeeklyMoodStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    return _firestore
        .collection('mood_entries')
        .where('userId', isEqualTo: user.uid)
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MoodEntryModel.fromFirestore(doc)).toList();
    });
  }

  /// daily stream: mengambil entri mood untuk hari tertentu
  Stream<List<MoodEntryModel>> getMoodsForDay(DateTime day) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _firestore
        .collection('mood_entries')
        .where('userId', isEqualTo: user.uid)
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp',
            isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MoodEntryModel.fromFirestore(doc)).toList();
    });
  }

  /// monthly stream: mengambil entri mood untuk bulan tertentu
  Stream<List<MoodEntryModel>> getMoodsForMonth(int year, int month) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 1);

    return _firestore
        .collection('mood_entries')
        .where('userId', isEqualTo: user.uid)
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('timestamp',
            isLessThan: Timestamp.fromDate(endOfMonth))
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MoodEntryModel.fromFirestore(doc)).toList();
    });
  }
}