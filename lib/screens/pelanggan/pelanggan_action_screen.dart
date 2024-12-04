import 'package:flutter/material.dart';
import 'package:manajemen_kos/core/services/pelanggan_service.dart';
import 'package:manajemen_kos/models/Pelanggan.dart';

class PelangganActionScreen extends StatefulWidget {
  final Pelanggan? pelanggan;

  const PelangganActionScreen({super.key, this.pelanggan});

  @override
  State<PelangganActionScreen> createState() => _PelangganActionScreenState();
}

class _PelangganActionScreenState extends State<PelangganActionScreen> {
  final _formKey = GlobalKey<FormState>();
  final PelangganService _pelangganService = PelangganService();

  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _noHpController;

  @override
  void initState() {
    super.initState();

    // Inisialisasi ketika data pelanggan dikirim oleh parameter maka masukan, jika kosong maka isi string kosong
    _namaController = TextEditingController(text: widget.pelanggan?.nama ?? '');
    _alamatController =
        TextEditingController(text: widget.pelanggan?.alamat ?? '');
    _noHpController = TextEditingController(text: widget.pelanggan?.noHp ?? '');
  }

  Future<void> _savePelanggan() async {
    if (_formKey.currentState!.validate()) {
      final pelanggan = Pelanggan(
        id: widget.pelanggan?.id,
        nama: _namaController.text,
        alamat: _alamatController.text,
        noHp: _noHpController.text,
      );

      if (widget.pelanggan == null) {
        // Add new pelanggan
        await _pelangganService.addPelanggan(pelanggan.toMap());
      } else {
        // Update existing pelanggan
        await _pelangganService.updatePelanggan(
            pelanggan.id!, pelanggan.toMap());
      }

      Navigator.pop(context, pelanggan); // Return to previous screen
    }
  }

  Future<void> _deletePelanggan() async {
    _pelangganService.deletePelanggan(widget.pelanggan?.id ?? 0);
    Navigator.pop(context, widget.pelanggan); // Return to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.pelanggan == null ? 'Tambah Pelanggan' : 'Edit Pelanggan'),
        actions: [
          widget.pelanggan != null
              ? IconButton(
                  onPressed: () {
                    _deletePelanggan();
                  },
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ))
              : SizedBox()
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(labelText: 'Nama'),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _alamatController,
                  decoration: InputDecoration(labelText: 'Alamat'),
                  validator: (value) =>
                      value!.isEmpty ? 'Alamat tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _noHpController,
                  decoration: InputDecoration(labelText: 'No Hp'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'No Hp tidak boleh kosong' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _savePelanggan,
                  child: Text(
                      widget.pelanggan == null ? 'Tambah' : 'Simpan Perubahan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
