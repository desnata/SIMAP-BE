class ScholarshipModel {
  String id;
  String namaPenerima;
  String nim;
  String jurusan;
  String alamat;
  double latitude;
  double longitude;
  String fotoKtpUrl;
  String fotoBuktiPendukungUrl;
  DateTime tanggalPengajuan;

  ScholarshipModel({
    this.id = '',
    required this.namaPenerima,
    required this.nim,
    required this.jurusan,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.fotoKtpUrl,
    required this.fotoBuktiPendukungUrl, 
    required this.tanggalPengajuan,
  });

  Map<String, dynamic> toMap() {
    return {
      'namaPenerima': namaPenerima,
      'nim': nim,
      'jurusan': jurusan,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'fotoKtpUrl': fotoKtpUrl,
      'fotoBuktiPendukungUrl': fotoBuktiPendukungUrl,
      'tanggalPengajuan': tanggalPengajuan.toIso8601String(),
    };
  }

  factory ScholarshipModel.fromMap(String id, Map<String, dynamic> map) {
    return ScholarshipModel(
      id: id,
      namaPenerima: map['namaPenerima'] ?? '',
      nim: map['nim'] ?? '',
      jurusan: map['jurusan'] ?? '',
      alamat: map['alamat'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      fotoKtpUrl: map['fotoKtpUrl'] ?? '',
      fotoBuktiPendukungUrl: map['fotoBuktiPendukungUrl'] ?? '', 
      tanggalPengajuan: DateTime.parse(map['tanggalPengajuan']),
    );
  }
}