import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myweightapps/screen/registrasi.dart';
import 'package:myweightapps/tema.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myweightapps/navigator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final email = _emailController.text;
        final password = _passwordController.text;

        // Login dengan Firebase Authentication
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Berhasil login, simpan informasi pengguna di SharedPreferences
        final user = userCredential.user;
        if (user != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_id', user.uid);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainNavigator()),
          );
        }
      } catch (e) {
        setState(() {
          if (e is FirebaseAuthException) {
            if (e.code == 'user-not-found') {
              _errorMessage = 'Pengguna tidak ditemukan';
            } else if (e.code == 'wrong-password') {
              _errorMessage = 'Kata sandi salah';
            } else {
              _errorMessage = 'Terjadi kesalahan: ${e.message}';
            }
          } else {
            _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
          }
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: putih,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height /
                  3.5, // Atur tinggi gambar sesuai kebutuhan
              color: putih,
              child: Center(
                child: Image.asset(
                  'assets/images/login.png',
                  width: 195,
                  height: 195,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  color: putih,
                  child: Padding(
                    padding:
                        const EdgeInsets.all(16.0), // Padding di sekitar form
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: birutua,
                            ),
                          ),
                          const SizedBox(height: 20), // Jarak antar elemen
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: birutua,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('Login'),
                          ),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrasiScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Tidak punya akun? Sign up',
                                style: TextStyle(color: birutua),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
