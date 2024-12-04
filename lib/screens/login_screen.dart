import 'package:flutter/material.dart';
import 'package:manajemen_kos/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers untuk textfield username dan password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variabel untuk menyimpan pesan error
  String _errorMessage = '';

  // Fungsi untuk menangani login
  void handleLogin() {
    setState(() {
      // Reset pesan error terlebih dahulu
      _errorMessage = '';

      // Validasi login
      if (_usernameController.text == 'admin' &&
          _passwordController.text == 'admin') {
        // Redirect ke dashboard jika login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        // Tampilkan pesan error jika login gagal
        _errorMessage = "Username atau password salah";
      }
    });
  }

  @override
  void dispose() {
    // Untuk menutup controller ketika sudah tidak digunakan lagi
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 180.0,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Gambar tidak dapat dimuat');
                },
              ),
              const SizedBox(height: 20.0),
              // Form login
              Form(
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true, // Sembunyikan teks untuk password
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Menampilkan pesan error jika ada
                    if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 16.0),
                    // Tombol login
                    FilledButton(
                      onPressed: handleLogin,
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
