import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- 1. Fungsi Registrasi (Sign Up) ---
  Future<void> registerUser(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan data profil ke Firestore
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

  // --- 2. Fungsi Login (Sign In) ---
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
  
  // --- 3. Fungsi Logout (Berguna di Profile Page) ---
  Future<void> signOut() async {
    await _auth.signOut();
  }
}