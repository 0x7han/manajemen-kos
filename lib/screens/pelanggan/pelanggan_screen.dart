import 'package:flutter/material.dart';
import 'package:manajemen_kos/core/services/pelanggan_service.dart';
import 'package:manajemen_kos/models/Pelanggan.dart';
import 'package:manajemen_kos/screens/pelanggan/pelanggan_action_screen.dart';

class PelangganScreen extends StatefulWidget {
  const PelangganScreen({super.key});

  @override
  State<PelangganScreen> createState() => _PelangganScreenState();
}

class _PelangganScreenState extends State<PelangganScreen> {
  final PelangganService _pelangganService = PelangganService();
  List<Map<String, dynamic>> _pelangganList = [];

  @override
  void initState() {
    super.initState();
    _loadPelanggan();
  }

  Future<void> _loadPelanggan() async {
    try {
      final data = await _pelangganService.getAllPelanggan();
      setState(() {
        _pelangganList = data;
      });
    } catch (e) {
      print("Error loading pelanggan data: $e");
    }
  }

  void _refreshPelangganList() async {
    await _loadPelanggan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Pelanggan'),
      ),
      body: _pelangganList.isEmpty
          ? Center(child: Text('Belum ada data pelanggan.'))
          : ListView.builder(
              itemCount: _pelangganList.length,
              itemBuilder: (context, index) {
                final pelanggan = _pelangganList[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('${pelanggan['nama']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${pelanggan['id']}'),
                        Text('Alamat: ${pelanggan['alamat']}'),
                        Text('No Hp: ${pelanggan['no_hp']}'),
                      ],
                    ),
                    onTap: () async {
                      final updatedPelanggan = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PelangganActionScreen(
                            pelanggan: Pelanggan.fromMap(pelanggan),
                          ),
                        ),
                      );
                      if (updatedPelanggan != null) {
                        _refreshPelangganList();
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newPelanggan = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PelangganActionScreen()),
          );
          if (newPelanggan != null) {
            _refreshPelangganList();
          }
        },
      ),
    );
  }
}
