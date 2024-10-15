import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.ref().child('users');

  // Daftar pengguna baru
  Future<UserCredential?> register(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan data pengguna ke Realtime Database setelah registrasi
      if (userCredential.user != null) {
        await _userRef.child(userCredential.user!.uid).set({
          'username': username,
          'email': email,
        });
      }

      return userCredential;
    } catch (e) {
      print('Error during registration: $e');
      return null;
    }
  }

  // Masuk pengguna
  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  // Keluar pengguna
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Mendapatkan pengguna saat ini
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Ambil ID pengguna yang saat ini login
  String get userId => _auth.currentUser?.uid ?? '';

  // Ambil data pengguna dari Realtime Database
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      DataSnapshot snapshot = await _userRef.child(userId).get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}
