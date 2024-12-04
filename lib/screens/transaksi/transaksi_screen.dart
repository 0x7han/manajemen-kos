import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:manajemen_kos/core/services/transaksi_service.dart';
import 'package:manajemen_kos/models/Transaksi.dart';
import 'package:manajemen_kos/screens/transaksi/transaksi_action_screen.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final TransaksiService _transaksiService = TransaksiService();
  List<Map<String, dynamic>> _transaksiList = [];

  @override
  void initState() {
    super.initState();
    _loadTransaksi();
  }

  Future<void> _loadTransaksi() async {
    try {
      final data = await _transaksiService.getAllTransaksi();
      setState(() {
        _transaksiList = data;

        
      });
      print('LISTTT : ${_transaksiList}');
    } catch (e) {
      print("Error loading transaksi data: $e");
    }
  }

  void _refreshTransaksiList() async {
    await _loadTransaksi();
  }

  Future<void> _deleteTransaksi(int id) async {
    _transaksiService.deleteTransaksi(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Transaksi'),
      ),
      body: _transaksiList.isEmpty
          ? Center(child: Text('Belum ada data transaksi.'))
          : ListView.builder(
              itemCount: _transaksiList.length,
              itemBuilder: (context, index) {
                final transaksi = _transaksiList[index];
                final Uint8List? gambar = transaksi['barang_bukti']; // Ambil gambar sebagai BLOB

                // Widget untuk menampilkan gambar atau ikon default
                final gambarWidget = gambar != null && gambar.isNotEmpty
                    ? Image.memory(
                        gambar,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.hotel, size: 50);

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: gambarWidget,
                          title: Text('ID Transaksi : ${transaksi['id']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID Kamar: ${transaksi['id_kamar']}'),
                              Text('ID Pelanggan: ${transaksi['id_pelanggan']}'),
                              Text('Lama Sewa: ${transaksi['jml_bulan']} bulan'),
                              Text('Total Harga: Rp ${transaksi['total_harga']}'),
                              Text('Tanggal: ${transaksi['tanggal']}'),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            _deleteTransaksi(transaksi['id']);
                            _refreshTransaksiList();
                          },
                          icon: Icon(Icons.delete_forever))
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newTransaksi = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TransaksiActionScreen()),
          );
          if (newTransaksi != null) {
            _refreshTransaksiList();
          }
        },
      ),
    );
  }
}
