class SensorModel {
  DateTime time;
  double beratBadan;

  SensorModel({required this.time, required this.beratBadan});

  // Factory method untuk menangani format data baru
  factory SensorModel.fromMap(String timeKey, String beratBadanValue) {
    return SensorModel(
      time: DateTime.parse(timeKey),
      beratBadan: double.parse(beratBadanValue),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'beratBadan': beratBadan.toString(),
    };
  }
}
