class Pelanggan {
  final int? id;
  final String nama;
  final String alamat;
  final String noHp;

  Pelanggan({
    this.id,
    required this.nama,
    required this.alamat,
    required this.noHp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'no_hp': noHp,
    };
  }

  factory Pelanggan.fromMap(Map<String, dynamic> map) {
    return Pelanggan(
      id: map['id'],
      nama: map['nama'],
      alamat: map['alamat'],
      noHp: map['no_hp'],
    );
  }
}
