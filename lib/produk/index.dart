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
    home: MenuPage(title: 'Home Produk'),
  ));
}

class MenuPage extends StatefulWidget {
  final String title;

  const MenuPage({super.key, required this.title});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final response = await Supabase.instance.client
          .from('produk')
          .select()
          .order('ProdukID', ascending: true);

      if (response == null || response.isEmpty) {
        setState(() {
          produk = [];
        });
      } else {
        setState(() {
          produk = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data produk. Silakan coba lagi.';
      });
    } finally {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus produk: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Produk Cookies'),
        backgroundColor: Colors.brown[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                  color: Colors.brown, size: 30),
            )
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                )
              : produk.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada produk.',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: produk.length,
                      itemBuilder: (context, index) {
                        final prd = produk[index];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(prd['NamaProduk'] ?? 'Nama Tidak Tersedia'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Harga: ${prd['Harga']}'),
                                Text('Stok: ${prd['Stok']}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
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
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Batal'),
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
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (context) => _TambahProdukDialog(),
          );
          if (result != null) {
            try {
              await Supabase.instance.client.from('produk').insert([
                {
                  'NamaProduk': result['nama'],
                  'Harga': result['harga'],
                  'Stok': result['stok'],
                }
              ]);
              fetchProduk();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal menambahkan produk: $e')),
              );
            }
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.brown[600],
      ),
    );
  }
}

class _TambahProdukDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String? nama;
  double? harga;
  int? stok;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Produk Baru'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              label: 'Nama Produk',
              onChanged: (value) => nama = value,
              validator: (value) =>
                  value!.isEmpty ? 'Nama produk tidak boleh kosong' : null,
            ),
            _buildTextField(
              label: 'Harga',
              onChanged: (value) => harga = double.tryParse(value),
              validator: (value) =>
                  double.tryParse(value!) == null ? 'Harga tidak valid' : null,
            ),
            _buildTextField(
              label: 'Stok',
              onChanged: (value) => stok = int.tryParse(value),
              validator: (value) =>
                  int.tryParse(value!) == null ? 'Stok tidak valid' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {'nama': nama, 'harga': harga, 'stok': stok});
            }
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required void Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
