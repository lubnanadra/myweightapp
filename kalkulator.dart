import 'package:flutter/material.dart';
import 'package:myweightapps/tema.dart';
import 'package:myweightapps/utils/kalkulator_imb.dart';

class KalkulatorScreen extends StatefulWidget {
  const KalkulatorScreen({super.key});

  @override
  KalkulatorScreenState createState() => KalkulatorScreenState();
}

class KalkulatorScreenState extends State<KalkulatorScreen> {
  String _selectedGender = '';
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  double _bmi = 0;
  String _bmiCategory = '';
  String _bmiDescription = '';

  void _calculateBMI() {
    final double height = double.tryParse(_heightController.text) ?? 0;
    final double weight = double.tryParse(_weightController.text) ?? 0;

    if (height > 0 && weight > 0) {
      setState(() {
        _bmi = calculateBMI(weight, height / 100);
        _bmiCategory = categorizeBMI(_bmi);
        _bmiDescription = bmiDescription(_bmi);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Kalkulator BMI',
          style: semibold14.copyWith(color: putih, fontSize: 20),
        ),
        backgroundColor: birutua,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Jenis Kelamin',
                style: semibold14.copyWith(color: birutua, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = 'Laki-laki';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedGender == 'Laki-laki'
                                ? birutua
                                : abuabu,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/cowo.png',
                              height: 100,
                            ),
                            Text('Laki-laki',
                                style: regular14.copyWith(color: birutua)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = 'Perempuan';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedGender == 'Perempuan'
                                ? birutua
                                : abuabu,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/cewe.png',
                              height: 100,
                            ),
                            Text('Perempuan',
                                style: regular14.copyWith(color: birutua)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Tinggi Badan (cm)',
                  style: semibold12_5.copyWith(color: birutua, fontSize: 20),
                  textAlign: TextAlign.center),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan tinggi badan dalam cm',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Berat Badan (kg)',
                style: semibold12_5.copyWith(color: birutua, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan berat badan dalam kg',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _calculateBMI,
                child: Text(
                  'Hitung BMI',
                  style: semibold12_5.copyWith(color: birumuda),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'BMI Anda adalah:',
                    style: semibold14.copyWith(color: birumuda, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _bmi.toStringAsFixed(1),
                    style: bold18.copyWith(color: birumuda, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _bmiCategory,
                    style: regular14.copyWith(color: birumuda, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _bmiDescription,
                    style: regular14.copyWith(color: birumuda, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
