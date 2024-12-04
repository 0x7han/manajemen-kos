import 'dart:typed_data';

class Transaksi {
  final int? id;
  final int idKamar;
  final int idPelanggan;
  final int jmlBulan;
  final int totalHarga;
  final Uint8List? barangBukti; // Ubah tipe gambar menjadi Uint8List
  final String tanggal;

  Transaksi({
    this.id,
    required this.idKamar,
    required this.idPelanggan,
    required this.jmlBulan,
    required this.totalHarga,
    required this.barangBukti,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_kamar': idKamar,
      'id_pelanggan': idPelanggan,
      'jml_bulan': jmlBulan,
      'total_harga': totalHarga,
      'barang_bukti' : barangBukti,
      'tanggal': tanggal,
    };
  }

  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'],
      idKamar: map['id_kamar'],
      idPelanggan: map['id_pelanggan'],
      jmlBulan: map['jml_bulan'],
      totalHarga: map['total_harga'],
      barangBukti: map['barang_bukti'],
      tanggal: map['tanggal'],
    );
  }
}
