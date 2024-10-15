import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:myweightapps/models/sensormodel.dart';
import 'package:myweightapps/models/user_model.dart';

class DatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  // Simpan data pengguna
  Future<void> saveUser(User user) async {
    try {
      await _db.child('users').child(user.id).set(user.toJson());
      print('User saved successfully.');
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  // Simpan data sensor dengan timestamp saat ini
  Future<void> saveSensorData(SensorModel sensorModel) async {
    try {
      final String timeString = DateTime.now().toIso8601String();
      await _db.child('sensordata').child(timeString).set(sensorModel.toJson());
      print('Sensor data saved successfully.');
    } catch (e) {
      print('Error saving sensor data: $e');
    }
  }

  // Stream data sensor secara real-time
  Stream<List<SensorModel>> getSensorData() {
    return _db.child('sensordata').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        return data.entries.map((entry) {
          final timeKey = entry.key as String;
          final value = entry.value as String;
          return SensorModel.fromMap(timeKey, value);
        }).toList();
      } else {
        return <SensorModel>[];
      }
    }).handleError((e) {
      print('Error streaming sensor data: $e');
    });
  }

  // Ambil data sensor terbaru dari Realtime Database
  Future<SensorModel?> getLatestSensorData() async {
    try {
      final snapshot =
          await _db.child('sensordata').orderByKey().limitToLast(1).get();
      final data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null && data.isNotEmpty) {
        final timeKey = data.keys.first as String;
        final beratBadanValue = data.values.first as String;
        return SensorModel.fromMap(timeKey, beratBadanValue);
      }
      print('No valid sensor data found.');
    } catch (e) {
      print('Error getting latest sensor data: $e');
    }
    return null;
  }

  // Ambil data pengguna berdasarkan ID
  Future<User?> getUser(String userId) async {
    try {
      final snapshot = await _db.child('users').child(userId).get();
      final data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        return User.fromJson(Map<String, dynamic>.from(data));
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
    return null;
  }

  // Ambil data pengguna saat ini
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        return getUser(firebaseUser.uid);
      }
    } catch (e) {
      print('Error getting current user: $e');
    }
    return null;
  }
}
