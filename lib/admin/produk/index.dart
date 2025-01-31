import 'package:flutter/material.dart';
import 'package:kasirr/admin/detailpenjualan/produk/update.dart';
import 'package:kasirr/detailpenjualan/index.dart';
import 'package:kasirr/admin/produk/update.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.brown,
    ),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange), // Warna teks
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdukTab()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Warna tombol
                foregroundColor: Colors.white,
              ),
              child: Text('Pergi ke Produk'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TambahProdukDialog extends StatefulWidget {
  @override
  State<_TambahProdukDialog> createState() => _TambahProdukDialogState();
}

class _TambahProdukDialogState extends State<_TambahProdukDialog> {
  final _NamaController = TextEditingController();
  final _HargaController = TextEditingController();
  final _StokController = TextEditingController();

  @override
  void dispose() {
    _NamaController.dispose();
    _HargaController.dispose();
    _StokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Produk'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _NamaController,
            decoration: InputDecoration(labelText: 'Nama Produk'),
          ),
          TextField(
            controller: _HargaController,
            decoration: InputDecoration(labelText: 'Harga'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _StokController,
            decoration: InputDecoration(labelText: 'Stok'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            if (_NamaController.text.isNotEmpty &&
                _HargaController.text.isNotEmpty &&
                _StokController.text.isNotEmpty) {
              Navigator.pop(
                context,
                {
                  'nama': _NamaController.text,
                  'harga': double.tryParse(_HargaController.text),
                  'stok': int.tryParse(_StokController.text),
                },
              );
            }
          },
          child: Text('Tambah'),
        ),
      ],
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

      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
      });
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
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
                    style: TextStyle(fontSize: 18, color: Colors.red), // Pesan error
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
                        return _buildProdukCard(context, prd);
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
              await Supabase.instance.client.from('produk').insert([{
                'NamaProduk': result['nama'],
                'Harga': result['harga'],
                'Stok': result['stok'],
              }]);
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

  Widget _buildProdukCard(BuildContext context, Map<String, dynamic> prd) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () => _showOrderDialog(context, prd),
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
                    builder: (context) => EditProduk(ProdukID: prd['ProdukID']),
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
                      content: Text('Apakah Anda yakin ingin menghapus produk ini?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
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
  }

  void _showOrderDialog(BuildContext context, Map<String, dynamic> prd) {
  int jumlahPesanan = 1;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Center(
          child: Text(
            'Pesan Produk',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text('Pesan ${prd['NamaProduk']}'),
                ),
                Center(
                  child: Text('Harga: ${prd['Harga']}'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          if (jumlahPesanan > 1) {
                            jumlahPesanan--;
                          }
                        });
                      },
                    ),
                    Text(
                      '$jumlahPesanan',
                      style: TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          if (jumlahPesanan < (prd['Stok'] ?? 0)) {
                            jumlahPesanan++;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.brown),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              if (jumlahPesanan > 0 && jumlahPesanan <= (prd['Stok'] ?? 0)) {
                try {
                  // Menyimpan pesanan ke tabel pesanan
                  final response = await Supabase.instance.client.from('pesanan').insert([{
                    'ProdukID': prd['ProdukID'],
                    'Jumlah': jumlahPesanan,
                    'TotalHarga': jumlahPesanan * (prd['Harga'] ?? 0),
                  }]).select().single(); // Mengambil data yang baru ditambahkan

                  // Mendapatkan ID pesanan yang baru saja ditambahkan
                  final pesananID = response['id']; // Pastikan untuk menyesuaikan dengan struktur data Anda

                  // Menyimpan detail pesanan ke tabel detailpenjualan
                  await Supabase.instance.client.from('detailpenjualan').insert([{
                    'PenjualanID': pesananID,
                    'ProdukID': prd['ProdukID'],
                    'JumlahProduk': jumlahPesanan,
                    'Subtotal': jumlahPesanan * (prd['Harga'] ?? 0),
                  }]);

                  // Mengupdate stok produk
                  await Supabase.instance.client
                      .from('produk')
                      .update({'Stok': (prd['Stok'] ?? 0) - jumlahPesanan})
                      .eq('ProdukID', prd['ProdukID']);

                  fetchProduk();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pesanan berhasil dibuat!')),
                  );

                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailPenjualanTab(prd: prd)));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal membuat pesanan: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Jumlah pesanan tidak valid!')),
                );
              }
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.brown,
            ),
            label: Text('Pesan', style: TextStyle(color: Colors.brown)),
          ),
        ],
      );
    },
  );
}
}
