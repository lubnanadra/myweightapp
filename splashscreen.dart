import 'package:flutter/material.dart';
import 'package:myweightapps/tema.dart';
import 'loginscreen.dart';
import 'registrasi.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: putih,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splashscreen.png',
              width: 333,
              height: 296,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '"Successful Weight Loss Takes Programming, Not Will Power"',
                style: bold18.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '- Phil McGraw',
                style: bold18.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            // Tombol Login
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: abuabu,
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                textStyle: bold16.copyWith(fontSize: 18),
              ),
              child: Text(
                'Log in',
                style: bold16.copyWith(color: birutua),
              ),
            ),
            const SizedBox(height: 20),
            // Tombol Signup
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistrasiScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: birutua,
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                textStyle: bold16.copyWith(color: putih, fontSize: 18),
              ),
              child: Text(
                'Sign up',
                style: bold16.copyWith(color: putih),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
