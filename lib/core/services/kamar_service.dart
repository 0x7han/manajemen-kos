

import 'package:manajemen_kos/core/helpers/database_helper.dart';

class KamarService {
  final dbHelper = DatabaseHelper.instance;

  Future<int> addKamar(Map<String, dynamic> kamar) async {
    final db = await dbHelper.database;
    return await db.insert('kamar', kamar);
  }

  Future<List<Map<String, dynamic>>> getAllKamar() async {
    final db = await dbHelper.database;
    return await db.query('kamar');
  }

  Future<int> updateKamar(int id, Map<String, dynamic> kamar) async {
    final db = await dbHelper.database;
    return await db.update('kamar', kamar, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteKamar(int id) async {
    final db = await dbHelper.database;
    return await db.delete('kamar', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> reduceKuota(int id) async {
    final db = await dbHelper.database;
    final kamar = await db.query('kamar', where: 'id = ?', whereArgs: [id]);

    if (kamar.isNotEmpty) {
      int kuota = kamar.first['kuota'] as int;
      if (kuota > 0) {
        kuota--;
        String status = kuota == 0 ? 'penuh' : 'tersedia';
        await db.update(
          'kamar',
          {'kuota': kuota, 'status': status},
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    }
  }
}
