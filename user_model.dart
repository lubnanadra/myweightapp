class User {
  final String id;
  final String username;
  final String nama;
  final DateTime tanggalLahir;
  final int tinggiBadan;
  final String jenisKelamin;

  User({
    required this.id,
    required this.username,
    required this.nama,
    required this.tanggalLahir,
    required this.tinggiBadan,
    required this.jenisKelamin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      nama: json['nama'],
      tanggalLahir: DateTime.parse(json['tanggalLahir']),
      tinggiBadan: json['tinggiBadan'],
      jenisKelamin: json['jenisKelamin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'nama': nama,
      'tanggalLahir': tanggalLahir.toIso8601String(),
      'tinggiBadan': tinggiBadan,
      'jenisKelamin': jenisKelamin,
    };
  }
}
