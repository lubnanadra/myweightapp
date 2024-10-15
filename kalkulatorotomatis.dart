import 'package:myweightapps/models/user_model.dart';
import 'package:myweightapps/models/sensormodel.dart';

class IMTOtomatis {
  // Menghitung IMT (Indeks Massa Tubuh) berdasarkan tinggi badan (dalam cm) dan berat badan (dalam kg)
  static double otomatisIMT(double tinggiBadan, double beratBadan) {
    return beratBadan / (tinggiBadan * tinggiBadan); // Tinggi tetap dalam cm
  }

  // Mendapatkan kategori IMT berdasarkan nilai IMT
  static String IMTCategory(double imt) {
    if (imt < 18.5) return 'Kurus';
    if (imt < 25) return 'Ideal';
    if (imt < 27) return 'Kelebihan Berat Badan';
    return 'Obesitas';
  }

  // Mendapatkan deskripsi berdasarkan nilai IMT
  static String IMTDescription(double imt) {
    if (imt < 18.5) {
      return 'Anda kurang berat badan. Perhatikan pola makan dan konsultasikan dengan ahli gizi karena berisiko mengalami penyakit tertentu akibat kekurangan nutrisi.';
    }
    if (imt < 25) {
      return 'Anda memiliki berat badan ideal. Pertahankan gaya hidup sehat.';
    }
    if (imt < 27) {
      return 'Anda mengalami kelebihan berat badan. Pertimbangkan untuk meningkatkan aktivitas fisik. Kelebihan berat badan dapat meningkatkan risiko diabetes tipe 2, hipertensi, gangguan jantung, stroke, kanker, dan penyakit lainnya.';
    }
    return 'Anda mengalami obesitas. Konsultasikan dengan dokter untuk mendapatkan saran kesehatan.';
  }

  // Menghitung IMT, kategori, dan deskripsi berdasarkan data pengguna yang login dan data berat badan terbaru
  static Future<Map<String, dynamic>> IMTOtomatisForCurrentUser(
    User? user,
    SensorModel? latestSensorData,
  ) async {
    if (user == null || latestSensorData == null) {
      throw Exception('User atau data sensor tidak ada');
    }

    final tinggiBadan =
        user.tinggiBadan.toDouble(); // Gunakan dot operator langsung
    final beratBadan =
        latestSensorData.beratBadan.toDouble(); // Gunakan dot operator langsung

    final imt = otomatisIMT(tinggiBadan, beratBadan);
    final kategori = IMTCategory(imt);
    final deskripsi = IMTDescription(imt);

    return {
      'indeks': imt,
      'kategori': kategori,
      'deskripsi': deskripsi,
    };
  }
}
