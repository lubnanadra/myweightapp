double calculateBMI(double weight, double height) {
  return weight / (height * height);
}

String categorizeBMI(double bmi) {
  if (bmi < 18.4) return 'Kurus';
  if (bmi < 25) return 'Ideal';
  if (bmi < 27) return 'Kelebihan Berat Badan';
  return 'Obesitas';
}

String bmiDescription(double bmi) {
  if (bmi < 18.4)
    return 'Anda kurang berat badan. Perhatikan pola makan dan konsultasikan dengan ahli gizi karena berisiko mengalami penyakit tertentu akibat kekurangan nutrisi.';
  if (bmi < 25)
    return 'Anda memiliki berat badan ideal. Pertahankan gaya hidup sehat.';
  if (bmi < 27)
    return 'Anda mengalami kelebihan berat badan. Pertimbangkan untuk meningkatkan aktivitas fisik. Kelebihan berat badan dapat meningkatkan risiko diabetes tipe 2, hipertensi, gangguan jantung stroke, kanker dan  penyakit lainnya';
  return 'Anda mengalami obesitas. Konsultasikan dengan dokter untuk mendapatkan saran kesehatan.';
}
