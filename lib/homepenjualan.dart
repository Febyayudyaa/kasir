import 'package:flutter/material.dart';
import 'package:kasirr/admin/detailpenjualan/index.dart';
import 'login.dart';
import 'package:kasirr/admin/pelanggan/index.dart';
import 'package:kasirr/admin/produk/index.dart';
import 'package:kasirr/admin/penjualan/index.dart';
import 'package:kasirr/admin/registrasi/indexregistrasi.dart'; 

void main() async {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: MenuPage(title: 'Beranda Penjualan', isPetugas: true, ),  
  ));
}

class MenuPage extends StatefulWidget {
  final String title;
  final bool isPetugas; 
  

  const MenuPage({Key? key, required this.title, this.isPetugas = false, })
      : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = -1;

  final List<Widget> _pages = [
    IndexProduk(),
    PelangganTab(),
    IndexPenjualan(),
    IndexDetailJual(prd: {
      'ProdukID': 1,
      'NamaProduk': 'Produk A',
      'Harga': 100000,
      'Stok': 50,
    }),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != -1) {
          setState(() {
            _selectedIndex = -1;  // Kembali ke halaman Beranda Penjualan
          });
          return false;  // Jangan kembali ke halaman login
        }
        return true;  // Kembali ke halaman sebelumnya (keluar aplikasi)
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _selectedIndex == -1
            ? AppBar(
                title: Text(widget.title),
                backgroundColor: Colors.brown[800],
                foregroundColor: Colors.white,
                leading: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'logout') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    } else if (value == 'registrasi') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IndexRegistrasi()),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 'logout',
                        child: Text('Logout'),
                      ),
                      if (!widget.isPetugas)  
                        const PopupMenuItem(
                          value: 'registrasi',
                          child: Text('Registrasi'),
                        ),
                    ];
                  },
                ),
              )
            : null, 
        body: _selectedIndex == -1 
            ? Center(  
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: [
                    SizedBox(height: 20),
                    Text(
                      widget.isPetugas
                          ? 'Anda login sebagai Petugas'
                          : 'Anda login sebagai Admin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Produk'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pelanggan'),
            if (!widget.isPetugas)  
              BottomNavigationBarItem(icon: Icon(Icons.point_of_sale), label: 'Penjualan'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Detail Penjualan'),
          ],
          currentIndex: _selectedIndex == -1 ? 0 : _selectedIndex,
          selectedItemColor: Colors.brown[800],
          unselectedItemColor: Colors.brown[200],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
