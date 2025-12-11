import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileData {
  final String fullName;
  final String email;
  final String? phone;
  final String? gender;
  final DateTime? birthday;
  final String? username;
  final String? photoUrl;
  
  ProfileData({
    required this.fullName, 
    required this.email, 
    this.phone, 
    this.gender, 
    this.birthday, 
    this.username,
    this.photoUrl
  });
}
class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  // Register User
  Future<void> registerUser(String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'email': email,
          'name': name,
          'createdAt': Timestamp.now(),
        });

        await userCredential.user!.updateDisplayName(name);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'Password yang Anda masukkan terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email tersebut sudah terdaftar.';
      } else {
        message = 'Error registrasi: ${e.message}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Terjadi error: $e');
    }
  }

  // Login User
  Future<void> signInUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Email atau Password yang Anda masukkan salah.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid.';
      } else {
        message = 'Terjadi kesalahan: ${e.message}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Terjadi error: $e');
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Update Data User
  Future<void> updateUserData({
    String? name,
    String? email,
    String? phone, 
    String? gender, 
    DateTime? birthday, 
    String? username,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User is not logged in.");
    }

    final Map<String, dynamic> firestoreUpdates = {};

    // Update Display Name (Firebase Auth) & Firestore Name
    if (name != null && name.isNotEmpty) {
      await user.updateDisplayName(name);
      firestoreUpdates['name'] = name;
    }

    // Update Email (Firebase Auth) & Firestore Email
    if (email != null && email.isNotEmpty && email != user.email) {
      await user.verifyBeforeUpdateEmail(email);
      firestoreUpdates['email'] = email;
    }
    
    // Update Field Baru (Firestore)
    if (phone != null) firestoreUpdates['phone'] = phone;
    if (gender != null) firestoreUpdates['gender'] = gender;
    if (username != null) firestoreUpdates['username'] = username;

    if (birthday != null) firestoreUpdates['birthday'] = Timestamp.fromDate(birthday);

    if (firestoreUpdates.isNotEmpty) {
      await _firestore.collection('users').doc(user.uid).set(
        firestoreUpdates,
        SetOptions(merge: true),
      );
    }

    await user.reload();
  }

  // Fetch Profile Data
  Future<ProfileData> fetchProfileData() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in.");

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data();

    final birthday = (data?['birthday'] as Timestamp?)?.toDate();
    final firestoreFullName = data?['name'] as String?;

    return ProfileData(
      fullName: firestoreFullName ?? user.displayName ?? 'N/A',
      email: user.email ?? 'N/A',
      username: data?['username'],
      phone: data?['phone'],
      gender: data?['gender'],
      birthday: birthday,
      photoUrl: user.photoURL,
    );
  }
}
