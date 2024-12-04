import 'package:manajemen_kos/core/helpers/database_helper.dart';
import 'package:manajemen_kos/core/services/kamar_service.dart';

class TransaksiService {
  final dbHelper = DatabaseHelper.instance;

  Future<int> addTransaksi(Map<String, dynamic> transaksi) async {
    final db = await dbHelper.database;

    // Reduce kamar kuota on transaksi
    await KamarService().reduceKuota(transaksi['id_kamar']);
    
    return await db.insert('transaksi', transaksi);
  }

  Future<List<Map<String, dynamic>>> getAllTransaksi() async {
    final db = await dbHelper.database;
    return await db.query('transaksi');
  }

  Future<int> deleteTransaksi(int id) async {
    final db = await dbHelper.database;
    return await db.delete('transaksi', where: 'id = ?', whereArgs: [id]);
  }
}
