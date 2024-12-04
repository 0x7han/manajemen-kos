import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manajemen_kos/core/services/kamar_service.dart';
import 'package:manajemen_kos/core/services/pelanggan_service.dart';
import 'package:manajemen_kos/core/services/transaksi_service.dart';

import 'package:manajemen_kos/models/Transaksi.dart';

class TransaksiActionScreen extends StatefulWidget {
  const TransaksiActionScreen({super.key});

  @override
  State<TransaksiActionScreen> createState() => _TransaksiActionScreenState();
}

class _TransaksiActionScreenState extends State<TransaksiActionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TransaksiService _transaksiService = TransaksiService(); // Layanan transaksi
  final KamarService _kamarService = KamarService(); // Layanan kamar
  final PelangganService _pelangganService = PelangganService(); // Layanan pelanggan

  List<Map<String, dynamic>> _kamarList = []; // Data kamar
  List<Map<String, dynamic>> _pelangganList = []; // Data pelanggan

  Uint8List? _imageBytes; // Variabel untuk menyimpan binary data gambar
  final TextEditingController _idKamar = TextEditingController();
  final TextEditingController _idPelanggan = TextEditingController();
  final TextEditingController _jmlBulan = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDataPelangganKamar(); // Memuat data pelanggan dan kamar
  }

  Future<void> _loadDataPelangganKamar() async {
    try {
      // Memuat data pelanggan dan kamar
      final pelanggans = await _pelangganService.getAllPelanggan();
      final kamars = await _kamarService.getAllKamar();
      setState(() {
        _pelangganList = pelanggans;
        _kamarList = kamars;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  Future<void> _pickImage() async {
    // Menggunakan ImagePicker untuk memilih gambar
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes(); // Membaca binary data
      setState(() {
        _imageBytes = bytes; // Menyimpan gambar sebagai binary
      });
    }
  }

  Future<void> _saveTransaksi() async {
    if (_formKey.currentState!.validate()) {
      // Hitung total harga berdasarkan jumlah bulan dan tarif kamar
      final kamar = _kamarList.firstWhere(
        (k) => k['id'] == int.parse(_idKamar.text),
        orElse: () => {'tarif': 0},
      );
      final int tarifPerBulan = kamar['tarif'] ?? 0;
      final int jumlahBulan = int.parse(_jmlBulan.text);
      final int totalHarga = tarifPerBulan * jumlahBulan;

      // Membuat objek Transaksi
      final transaksi = Transaksi(
        barangBukti: _imageBytes, // Binary data untuk gambar
        idKamar: int.parse(_idKamar.text), // ID kamar
        idPelanggan: int.parse(_idPelanggan.text), // ID pelanggan
        jmlBulan: jumlahBulan, // Jumlah bulan
        totalHarga: totalHarga, // Total harga
        tanggal: DateTime.now().toString(), // Tanggal transaksi
      );

      // Menyimpan transaksi ke database
      await _transaksiService.addTransaksi(transaksi.toMap());
      Navigator.pop(context, transaksi); // Kembali ke layar sebelumnya
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage, // Memilih gambar
                  child: _imageBytes == null
                      ? Column(
                          children: [
                            Text('Upload Bukti Transaksi'),
                            const Icon(Icons.image, size: 100),
                          ],
                        )
                      : Image.memory(
                          _imageBytes!,
                          height: 100, // Menampilkan gambar jika ada
                        ),
                ),

                const SizedBox(height: 20),

                // Dropdown untuk memilih kamar
                DropdownButtonFormField(
                  items: _kamarList.map((kamar) {
                    return DropdownMenuItem(
                      value: kamar['id'].toString(),
                      child: Text('${kamar['tipe']} - ${kamar['tarif']}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _idKamar.text = value.toString(); // Menyimpan ID kamar yang dipilih
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Pilih Kamar'),
                  validator: (value) =>
                      value == null ? 'Harap pilih kamar' : null,
                ),

                const SizedBox(height: 20),

                // Dropdown untuk memilih pelanggan
                DropdownButtonFormField(
                  items: _pelangganList.map((pelanggan) {
                    return DropdownMenuItem(
                      value: pelanggan['id'].toString(),
                      child: Text('${pelanggan['nama']}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _idPelanggan.text = value.toString(); // Menyimpan ID pelanggan yang dipilih
                    });
                  },
                  decoration:
                      const InputDecoration(labelText: 'Pilih Pelanggan'),
                  validator: (value) =>
                      value == null ? 'Harap pilih pelanggan' : null,
                ),

                const SizedBox(height: 20),

                // TextField untuk jumlah bulan
                TextFormField(
                  controller: _jmlBulan,
                  decoration: const InputDecoration(labelText: 'Jumlah Bulan'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Harap isi jumlah bulan'
                      : null,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _saveTransaksi, // Simpan transaksi
                  child: const Text('Tambah'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
