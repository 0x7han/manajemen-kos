import 'package:manajemen_kos/core/helpers/database_helper.dart';

class PelangganService {
  final dbHelper = DatabaseHelper.instance;

  Future<int> addPelanggan(Map<String, dynamic> pelanggan) async {
    final db = await dbHelper.database;
    return await db.insert('pelanggan', pelanggan);
  }

  Future<List<Map<String, dynamic>>> getAllPelanggan() async {
    final db = await dbHelper.database;
    return await db.query('pelanggan');
  }

  Future<int> updatePelanggan(int id, Map<String, dynamic> pelanggan) async {
    final db = await dbHelper.database;
    return await db.update('pelanggan', pelanggan, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deletePelanggan(int id) async {
    final db = await dbHelper.database;
    return await db.delete('pelanggan', where: 'id = ?', whereArgs: [id]);
  }
}
