import 'dart:typed_data';

class Kamar {
  final int? id;
  final Uint8List? gambar; // Ubah tipe gambar menjadi Uint8List
  final String tipe;
  final String fasilitas;
  final int tarif;
  final int kuota;
  final String status;
  final String keterangan;

  Kamar({
    this.id,
    required this.gambar,
    required this.tipe,
    required this.fasilitas,
    required this.tarif,
    required this.kuota,
    required this.status,
    required this.keterangan,
  });

  // Convert Kamar to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gambar': gambar,
      'tipe': tipe,
      'fasilitas': fasilitas,
      'tarif': tarif,
      'kuota': kuota,
      'status': status,
      'keterangan': keterangan,
    };
  }

  // Create Kamar from Map
  factory Kamar.fromMap(Map<String, dynamic> map) {
    return Kamar(
      id: map['id'],
      gambar: map['gambar'],
      tipe: map['tipe'],
      fasilitas: map['fasilitas'],
      tarif: map['tarif'],
      kuota: map['kuota'],
      status: map['status'],
      keterangan: map['keterangan'],
    );
  }
}
