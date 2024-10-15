import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myweightapps/screen/loginscreen.dart';
import 'package:myweightapps/tema.dart';

class RegistrasiScreen extends StatefulWidget {
  const RegistrasiScreen({super.key});

  @override
  RegistrasiScreenState createState() => RegistrasiScreenState();
}

class RegistrasiScreenState extends State<RegistrasiScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _namaController = TextEditingController();
  final _tinggiBadanController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  String? _jenisKelamin;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _namaController.dispose();
    _tinggiBadanController.dispose();
    _tanggalLahirController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      final String formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDate);
      setState(() {
        _tanggalLahirController.text = formattedDate;
      });
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        final user = userCredential.user;
        if (user != null) {
          final userId = user.uid;

          await FirebaseDatabase.instance.ref('users/$userId').set({
            'id': userId,
            'email': _emailController.text,
            'username': _usernameController.text,
            'nama': _namaController.text,
            'tanggalLahir': _tanggalLahirController.text,
            'jenisKelamin': _jenisKelamin!,
            'tinggiBadan': double.parse(_tinggiBadanController.text),
          });

          // Berhasil, navigate ke halaman login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } catch (e) {
        setState(() {
          if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
            _errorMessage = 'Email sudah digunakan';
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
        title: Text(
          'Registrasi',
          style: semibold14.copyWith(color: putih, fontSize: 18),
        ),
        backgroundColor: birutua,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.2,
            color: putih,
            child: Center(
              child: Image.asset(
                'assets/images/login.png',
                width: 136,
                height: 131,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: putih,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Format email tidak valid';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _usernameController,
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan username';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan Password';
                            }
                            if (value.length < 6) {
                              return 'Password harus memiliki minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: const InputDecoration(
                              labelText: 'Konfirmasi Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan Konfirmasi Password';
                            }
                            if (value != _passwordController.text) {
                              return 'Password tidak sesuai';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _namaController,
                          decoration: const InputDecoration(labelText: 'Nama'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan Nama Lengkap';
                            }
                            return null;
                          },
                        ),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _tanggalLahirController,
                              decoration: const InputDecoration(
                                  labelText: 'Tanggal Lahir'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukkan Tanggal Lahir';
                                }
                                try {
                                  DateTime parsedDate = DateTime.parse(value);
                                  if (DateTime.now()
                                          .difference(parsedDate)
                                          .inDays <
                                      365 * 18) {
                                    return 'Harap pilih tanggal lahir yang valid';
                                  }
                                } catch (_) {
                                  return 'Format data salah';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _tinggiBadanController,
                          decoration: const InputDecoration(
                              labelText: 'Tinggi Badan (cm)'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan Tinggi Badan';
                            }
                            return null;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: _jenisKelamin,
                          decoration:
                              const InputDecoration(labelText: 'Jenis Kelamin'),
                          items: ['Laki-laki', 'Perempuan']
                              .map((gender) => DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _jenisKelamin = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Pilih jenis Kelamin';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: birutua,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 20)),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  'Register',
                                  style: semibold14.copyWith(
                                      color: putih, fontSize: 16),
                                ),
                        ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sudah punya akun? Sign In',
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
    );
  }
}
