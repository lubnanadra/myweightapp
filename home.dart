import 'package:flutter/material.dart';
import 'package:myweightapps/models/sensormodel.dart';
import 'package:myweightapps/models/user_model.dart';
import 'package:myweightapps/services/database_service.dart';
import 'package:myweightapps/tema.dart';
import 'package:myweightapps/utils/kalkulator_umur.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:myweightapps/utils/kalkulatorotomatis.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late final DatabaseService _databaseService;
  User? _user;
  SensorModel? _latestSensorData;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _databaseService = DatabaseService();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final currentUser = auth.FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final user = await _databaseService.getUser(currentUser.uid);
        final sensorData = await _databaseService.getLatestSensorData();

        setState(() {
          _user = user;
          _latestSensorData = sensorData;
        });
      } catch (e) {
        print('Error fetching data: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double beratBadan = _latestSensorData?.beratBadan ?? 0.0;
    final double tinggiBadan = _user?.tinggiBadan.toDouble() ?? 0.0;
    final double bmi = IMTOtomatis.otomatisIMT(tinggiBadan, beratBadan);
    final String bmiCategoryText = IMTOtomatis.IMTCategory(bmi);
    final String bmiDescriptionText = IMTOtomatis.IMTDescription(bmi);
    final int age = _user != null ? calculateAge(_user!.tanggalLahir) : 0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _user == null
            ? const CircularProgressIndicator()
            : RichText(
                text: TextSpan(
                  text: "Hai, ",
                  style: regular14.copyWith(fontSize: 18, color: putih),
                  children: [
                    TextSpan(
                      text: _user!.nama,
                      style: semibold14.copyWith(fontSize: 18, color: putih),
                    ),
                  ],
                ),
              ),
        backgroundColor: birutua,
      ),
      body: _user == null || _latestSensorData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    color: putih,
                    height: size.height,
                  ),
                  ClipPath(
                    clipper: ClipPathClass(),
                    child: Container(
                      height: size.height * 0.35,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF1D2456),
                            Color.fromARGB(255, 26, 19, 86)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.02,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Berat Badan Anda',
                            style: semibold14.copyWith(
                              fontSize: 18,
                              color: putih,
                            ),
                          ),
                          SizedBox(height: size.height * 0.04),
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1 + _animation.value * 0.1,
                                child: child,
                              );
                            },
                            child: Container(
                              width: size.width * 0.5,
                              height: size.width * 0.5,
                              decoration: BoxDecoration(
                                color: putih,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: beratBadan.toStringAsFixed(1),
                                    style: bold16.copyWith(
                                      color: birutua,
                                      fontSize: size.width * 0.13,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Kg',
                                        style: bold16.copyWith(
                                          color: birutua,
                                          fontSize: size.width * 0.05,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: size.height * 0.02),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.05),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      StatusCard(
                                        title: "Tinggi Badan",
                                        data: tinggiBadan.toString(),
                                        satuan: "cm",
                                      ),
                                      StatusCard(
                                        title: "Usia",
                                        data: '$age',
                                        satuan: "Tahun",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: size.height * 0.02),
                            width: size.width * 0.9,
                            height: size.height * 0.1,
                            decoration: BoxDecoration(
                              color: putih,
                            ),
                            child: Center(
                              child: Text(
                                bmi.toStringAsFixed(1),
                                style: bold16.copyWith(
                                  color: birutua,
                                  fontSize: size.height * 0.04,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: size.height * 0.01),
                            width: size.width * 0.9,
                            height: size.height * 0.08,
                            decoration: BoxDecoration(
                              color: putih,
                            ),
                            child: Center(
                              child: Text(
                                bmiCategoryText,
                                style: semibold14.copyWith(
                                  color: birutua,
                                  fontSize: size.height * 0.035,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: size.height * 0.02),
                            width: size.width * 0.9,
                            height: size.height * 0.2,
                            decoration: BoxDecoration(
                              color: putih,
                            ),
                            child: Center(
                              child: Text(
                                bmiDescriptionText,
                                style: regular14.copyWith(
                                  color: birutua,
                                  fontSize: size.height * 0.025,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.data,
    required this.satuan,
    required this.title,
  });

  final String data;
  final String satuan;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 150,
        height: 80,
        color: putih,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text: data,
                style: semibold14.copyWith(
                  color: birutua,
                  fontSize: 24,
                ),
                children: [
                  TextSpan(
                    text: satuan,
                    style: regular14.copyWith(
                      color: birutua,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: regular14.copyWith(
                color: birutua,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
