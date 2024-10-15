import 'package:flutter/material.dart';
import 'package:myweightapps/models/user_model.dart';
import 'package:myweightapps/screen/loginscreen.dart';
import 'package:myweightapps/services/database_service.dart';
import 'package:myweightapps/utils/kalkulator_umur.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myweightapps/tema.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();

    return Scaffold(
      body: FutureBuilder<User?>(
        future: databaseService.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('User not found'));
          }

          final user = snapshot.data!;
          final DateTime birthDate = user.tanggalLahir;
          final int age = calculateAge(birthDate);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Informasi Profil',
                    style: bold16.copyWith(color: birutua, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text(
                          'Nama',
                          style: regular14.copyWith(color: hitam),
                        ),
                        subtitle: Text(
                          user.nama,
                          style: semibold12_5.copyWith(color: hitam),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Username',
                          style: regular14.copyWith(color: hitam),
                        ),
                        subtitle: Text(
                          user.username,
                          style: semibold12_5.copyWith(color: hitam),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Data Diri',
                        style: bold16.copyWith(color: birutua),
                      ),
                      ListTile(
                        title: Text(
                          'Tanggal Lahir',
                          style: regular14.copyWith(color: hitam),
                        ),
                        subtitle: Text(
                          user.tanggalLahir.toLocal().toString().split(' ')[0],
                          style: semibold12_5.copyWith(color: hitam),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Usia',
                          style: regular14.copyWith(color: hitam),
                        ),
                        subtitle: Text(
                          '$age tahun',
                          style: semibold12_5.copyWith(color: hitam),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Tinggi Badan',
                          style: regular14.copyWith(color: hitam),
                        ),
                        subtitle: Text(
                          '${user.tinggiBadan} cm',
                          style: semibold12_5.copyWith(color: hitam),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Jenis Kelamin',
                          style: regular14.copyWith(color: hitam),
                        ),
                        subtitle: Text(
                          user.jenisKelamin,
                          style: semibold12_5.copyWith(color: hitam),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      // Logika untuk logout
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();

                      // Logout dari Firebase melalui UserService
                      await databaseService.getCurrentUser();

                      // Navigasi ke layar login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'Log Out',
                      style: regular14.copyWith(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
