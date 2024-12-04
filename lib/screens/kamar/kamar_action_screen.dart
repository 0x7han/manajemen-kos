import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manajemen_kos/core/services/kamar_service.dart';
import 'package:manajemen_kos/models/Kamar.dart';

class KamarActionScreen extends StatefulWidget {
  final Kamar? kamar;

  const KamarActionScreen({super.key, this.kamar});

  @override
  State<KamarActionScreen> createState() => _KamarActionScreenState();
}

class _KamarActionScreenState extends State<KamarActionScreen> {
  final _formKey = GlobalKey<FormState>();
  final KamarService _kamarService = KamarService();

  Uint8List? _imageBytes; // Ubah ke Uint8List untuk menyimpan binary data gambar
  late TextEditingController _tipeController;
  late TextEditingController _fasilitasController;
  late TextEditingController _tarifController;
  late TextEditingController _kuotaController;
  late TextEditingController _statusController;
  late TextEditingController _keteranganController;

  @override
  void initState() {
    super.initState();

    // Inisialisasi ketika data kamar dikirim oleh parameter
    _imageBytes = widget.kamar?.gambar;
    _tipeController = TextEditingController(text: widget.kamar?.tipe ?? '');
    _fasilitasController =
        TextEditingController(text: widget.kamar?.fasilitas ?? '');
    _tarifController =
        TextEditingController(text: widget.kamar?.tarif.toString() ?? '');
    _kuotaController =
        TextEditingController(text: widget.kamar?.kuota.toString() ?? '');
    _statusController = TextEditingController(text: widget.kamar?.status ?? '');
    _keteranganController =
        TextEditingController(text: widget.kamar?.keterangan ?? '');
  }

  Future<void> _pickImage() async {
    // Menggunakan ImagePicker untuk memilih gambar
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes(); // Membaca gambar sebagai binary
      setState(() {
        _imageBytes = bytes; // Menyimpan binary data gambar
      });
    }
  }

  Future<void> _saveKamar() async {
    if (_formKey.currentState!.validate()) {
      // Membuat objek Kamar
      final kamar = Kamar(
        id: widget.kamar?.id,
        gambar: _imageBytes, // Menyimpan gambar sebagai binary
        tipe: _tipeController.text,
        fasilitas: _fasilitasController.text,
        tarif: int.parse(_tarifController.text),
        kuota: int.parse(_kuotaController.text),
        status: _statusController.text,
        keterangan: _keteranganController.text,
      );

      if (widget.kamar == null) {
        // Menambahkan kamar baru
        await _kamarService.addKamar(kamar.toMap());
      } else {
        // Memperbarui data kamar yang ada
        await _kamarService.updateKamar(kamar.id!, kamar.toMap());
      }

      Navigator.pop(context, kamar); // Kembali ke layar sebelumnya
    }
  }

  Future<void> _deleteKamar() async {
    if (widget.kamar != null) {
      // Menghapus data kamar
      await _kamarService.deleteKamar(widget.kamar!.id!);
    }
    Navigator.pop(context, widget.kamar); // Kembali ke layar sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kamar == null ? 'Tambah Kamar' : 'Edit Kamar'),
        actions: [
          if (widget.kamar != null)
            IconButton(
              onPressed: _deleteKamar,
              icon: Icon(Icons.delete_forever, color: Colors.red),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                            Text('Upload foto'),
                            Icon(Icons.image, size: 100),
                          ],
                        )
                      : Image.memory(
                          _imageBytes!,
                          height: 100, // Menampilkan gambar jika ada
                        ),
                ),
                TextFormField(
                  controller: _tipeController,
                  decoration: InputDecoration(labelText: 'Tipe'),
                  validator: (value) =>
                      value!.isEmpty ? 'Tipe tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _fasilitasController,
                  decoration: InputDecoration(labelText: 'Fasilitas'),
                  validator: (value) =>
                      value!.isEmpty ? 'Fasilitas tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _tarifController,
                  decoration: InputDecoration(labelText: 'Tarif'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Tarif tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _kuotaController,
                  decoration: InputDecoration(labelText: 'Kuota'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Kuota tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _statusController,
                  decoration: InputDecoration(labelText: 'Status'),
                  validator: (value) =>
                      value!.isEmpty ? 'Status tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _keteranganController,
                  decoration: InputDecoration(labelText: 'Keterangan'),
                  validator: (value) =>
                      value!.isEmpty ? 'Keterangan tidak boleh kosong' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveKamar,
                  child: Text(
                      widget.kamar == null ? 'Tambah' : 'Simpan Perubahan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
