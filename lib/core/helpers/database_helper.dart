import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'rental_kamar.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create table for Kamar
    await db.execute('''
      CREATE TABLE kamar (
        id INTEGER PRIMARY KEY,
        gambar BLOB,
        tipe TEXT,
        fasilitas TEXT,
        tarif INTEGER,
        kuota INTEGER,
        status TEXT,
        keterangan TEXT
      )
    ''');

    // Create table for Pelanggan
    await db.execute('''
      CREATE TABLE pelanggan (
        id INTEGER PRIMARY KEY,
        nama TEXT,
        alamat TEXT,
        no_hp TEXT
      )
    ''');

    // Create table for Transaksi
    await db.execute('''
      CREATE TABLE transaksi (
        id INTEGER PRIMARY KEY,
        id_kamar INTEGER,
        id_pelanggan INTEGER,
        jml_bulan INTEGER,
        total_harga INTEGER,
        barang_bukti BLOB,
        tanggal TEXT,
        FOREIGN KEY (id_kamar) REFERENCES kamar (id),
        FOREIGN KEY (id_pelanggan) REFERENCES pelanggan (id)
      )
    ''');
  }
}
