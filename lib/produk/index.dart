import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kasirr/produk/insert.dart';
import 'package:kasirr/produk/update.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.brown),
    home: menupage(title: 'Home Penjualan'),
  ));
}

class menupage extends StatefulWidget {
  final String title;

  const menupage({super.key, required this.title});

  @override
  State<menupage> createState() => _menupageState();
}

class _menupageState extends State<menupage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.brown[800],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => menupage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat Datang di Halaman Penjualan!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdukTab()),
                );
              },
              child: Text('Pergi ke Produk'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[800],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProdukTab extends StatefulWidget {
  const ProdukTab({super.key});

  @override
  State<ProdukTab> createState() => _ProdukTabState();
}

class _ProdukTabState extends State<ProdukTab> {
  List<Map<String, dynamic>> produk = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client
          .from('produk')
          .select()
          .order('ProdukID', ascending: true);
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteProduk(int id) async {
    try {
      await Supabase.instance.client.from('produk').delete().eq('ProdukID', id);
      fetchProduk(); 
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Produk'),
        backgroundColor: Colors.brown[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => menupage(title: 'Home Penjualan')),
            );
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                  color: Colors.brown, size: 30),
            )
          : produk.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 12),
                  padding: EdgeInsets.all(8),
                  itemCount: produk.length,
                  itemBuilder: (context, index) {
                    final prd = produk[index];
                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Produk: ${prd['NamaProduk']}'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Harga: ${prd['Harga']}'),
                                Text('Stok: ${prd['Stok']}'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Tutup'))
                            ],
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prd['NamaProduk'] ?? 'Nama Tidak Tersedia',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(height: 4),
                              Text(
                                prd['Harga']?.toString() ?? 'Harga Tidak Tersedia',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                prd['Stok']?.toString() ?? 'Stok Tidak Tersedia',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProdukPage()),
          );

          if (result == true) {
            fetchProduk();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.brown[600],
        foregroundColor: Colors.white,
      ),
    );
  }
}
