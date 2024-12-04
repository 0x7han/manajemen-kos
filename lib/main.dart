import 'package:flutter/material.dart';
import 'package:manajemen_kos/core/helpers/database_helper.dart';
import 'package:manajemen_kos/screens/login_screen.dart';

void main() async {
  // Memastikan semua fitur siap sebelum eksekusi fungsi-fungsi dibawah
  WidgetsFlutterBinding.ensureInitialized();

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
