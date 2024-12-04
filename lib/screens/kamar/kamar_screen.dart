import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:manajemen_kos/core/services/kamar_service.dart';
import 'package:manajemen_kos/models/Kamar.dart';
import 'package:manajemen_kos/screens/kamar/kamar_action_screen.dart';

class KamarScreen extends StatefulWidget {
  const KamarScreen({super.key});

  @override
  State<KamarScreen> createState() => _KamarScreenState();
}

class _KamarScreenState extends State<KamarScreen> {
  final KamarService _kamarService = KamarService(); // Service untuk data kamar
  List<Map<String, dynamic>> _kamarList = []; // Data kamar dari database

  @override
  void initState() {
    super.initState();
    _loadKamar(); // Memuat data saat halaman dibuka
  }

  Future<void> _loadKamar() async {
    try {
      final data = await _kamarService.getAllKamar(); // Memuat data kamar dari database
      setState(() {
        _kamarList = data;
      });
    } catch (e) {
      print("Error loading kamar data: $e");
    }
  }

  void _refreshKamarList() async {
    await _loadKamar(); // Memuat ulang data kamar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Kamar'),
      ),
      body: _kamarList.isEmpty
          ? const Center(child: Text('Belum ada data kamar.')) // Tampilan jika tidak ada data
          : ListView.builder(
              itemCount: _kamarList.length,
              itemBuilder: (context, index) {
                final kamar = _kamarList[index];
                final Uint8List? gambar = kamar['gambar']; // Ambil gambar sebagai BLOB

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
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: gambarWidget, // Menampilkan gambar kamar
                    title: Text('${kamar['tipe']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${kamar['id']}'),
                        Text('Tarif: Rp. ${kamar['tarif']} / bulan'),
                        Text('Kuota: ${kamar['kuota']}'),
                        Text('Status: ${kamar['status']}'),
                      ],
                    ),
                    onTap: () async {
                      // Navigasi ke halaman Edit Kamar
                      final updatedKamar = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KamarActionScreen(
                            kamar: Kamar.fromMap(kamar), // Konversi data kamar dari map
                          ),
                        ),
                      );
                      if (updatedKamar != null) {
                        _refreshKamarList(); // Refresh data setelah update
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Navigasi ke halaman Tambah Kamar
          final newKamar = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KamarActionScreen()),
          );
          if (newKamar != null) {
            _refreshKamarList(); // Refresh data setelah tambah kamar
          }
        },
      ),
    );
  }
}
