import 'package:flutter/material.dart';
import 'package:manajemen_kos/screens/kamar/kamar_screen.dart';
import 'package:manajemen_kos/screens/login_screen.dart';
import 'package:manajemen_kos/screens/pelanggan/pelanggan_screen.dart';
import 'package:manajemen_kos/screens/transaksi/transaksi_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ini menu sidebar
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo-no-bg.png',
                    height: 80.0,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'TAGIHAN KOS',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Transaksi'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TransaksiScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Data Kamar'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => KamarScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Data Pelanggan'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PelangganScreen()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Tagihan Kos'),
        actions: [
          IconButton(
            onPressed: () {
              // Push stack ke login page
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Selamat datang, admin'),
          ],
        ),
      ),
    );
  }
}
