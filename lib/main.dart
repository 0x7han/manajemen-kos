import 'package:flutter/material.dart';
import 'package:manajemen_kos/core/helpers/database_helper.dart';
import 'package:manajemen_kos/screens/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  // Memastikan semua fitur siap sebelum eksekusi fungsi-fungsi dibawah
  WidgetsFlutterBinding.ensureInitialized();

  // Mendapatkan akses perizinan storage android
  var permission = await Permission.manageExternalStorage.status;

  if (!permission.isGranted) {
    await Permission.manageExternalStorage.request();
  }

  // Inisialisasi database
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database; // Buat dan buka database

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Manajemen Kos',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const LoginScreen());
  }
}
