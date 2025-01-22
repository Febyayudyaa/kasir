import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kasirr/produk/insert.dart';
import 'package:kasirr/produk/update.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasirr/homepenjualan.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.brown),
    home: menupage(title: 'Home Produk'),
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat Datang di Halaman Pembelian Produk!',
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

      Future<void> addProduk(String nama, double harga, int stok) async {
      try {
        final response = await Supabase.instance.client.from('produk').insert([
          {
            'NamaProduk': nama,
            'Harga': harga,
            'Stok': stok,
          }
        ]);
        if (response.error == null) {
          print('Produk berhasil ditambahkan');
        } else {
          print('Error menambahkan produk: ${response.error!.message}');
        }
      } catch (e) {
        print('Error: $e');
      }
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
      title: Text('Daftar Produk Cookies'),
      backgroundColor: Colors.brown[800],
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(
            context,
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
            : ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: produk.length,
                itemBuilder: (context, index) {
                  final prd = produk[index];
                  return InkWell(
                    onTap: () async {
                      int jumlah = 1;
                      final stok = prd['Stok'] ?? 0;
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Text('Produk: ${prd['NamaProduk']}'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Harga: ${prd['Harga']}'),
                                    Text('Stok Tersedia: $stok'),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove,
                                              color: Colors.brown[800]),
                                          onPressed: jumlah > 1
                                              ? () {
                                                  setState(() {
                                                    jumlah--;
                                                  });
                                                }
                                              : null,
                                        ),
                                        Text(
                                          '$jumlah',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add,
                                              color: Colors.brown[800]),
                                          onPressed: jumlah < stok
                                              ? () {
                                                  setState(() {
                                                    jumlah++;
                                                  });
                                                }
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context),
                                    child: Text('Batal',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, jumlah);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.brown[800],
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text('Tambahkan'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );

                      if (jumlah > 0 && jumlah <= stok) {
                        print('Produk: ${prd['NamaProduk']} - Jumlah: $jumlah');
                      }
                    },
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 120,
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prd['NamaProduk'] ?? 'Nama Tidak Tersedia',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(height: 4),
                              Text(
                                prd['Harga']?.toString() ?? 'Harga Tidak Tersedia',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 2),
                              Text(
                                prd['Stok']?.toString() ?? 'Stok Tidak Tersedia',
                                style: TextStyle(fontSize: 12),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.brown),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProduk(ProdukID: prd['ProdukID']),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.brown),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Konfirmasi'),
                                            content: Text(
                                                'Apakah Anda yakin ingin menghapus produk ini?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text('Batal',
                                                style: TextStyle(color: Colors.black),
                                              ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  deleteProduk(prd['ProdukID']);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Hapus'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
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
