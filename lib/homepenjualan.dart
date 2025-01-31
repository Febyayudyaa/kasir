import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';
import 'admin/pelanggan/index.dart';
import 'package:kasirr/admin/produk/index.dart';
import 'package:kasirr/admin/penjualan/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
     url: 'https://ejsimgpbrinksndwaann.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqc2ltZ3Bicmlua3NuZHdhYW5uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYzMzU0MTgsImV4cCI6MjA1MTkxMTQxOH0.99-o0u0wykWd3vSO_7kp6nDgKg3zFmvMDWFgzSQnNmw',
   );

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: MenuPage(title: 'Home Penjualan'),
  ));
}

class MenuPage extends StatefulWidget {
  final String title;
  MenuPage({Key? key, required this.title}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String? selectedOrderType;
  Map<String, int> cart = {}; 

  Map<String, dynamic> prd = {
    'ProdukID': 1,
    'NamaProduk': 'Produk A',
    'Harga': 100000,
    'Stok': 50,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        leading: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'logout') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ];
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Detail Penjualan', 'Produk', 'Penjualan', 'Pelanggan']
                  .map((label) => _buildCategoryButton(label, context))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton _buildCategoryButton(String label, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (label == 'Pelanggan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PelangganTab()),
          );
        } else if (label == 'Produk') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProdukTab()),
          );
        } else if (label == 'Penjualan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PenjualanTab()),
          );
        } else if (label == 'Detail Penjualan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPenjualanTab(prd: prd)), 
          );
        }
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[800]),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}