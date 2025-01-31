import 'package:flutter/material.dart';
import 'package:kasirr/admin/produk/insert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Pembelianproduk extends StatefulWidget {
  final Map<String, dynamic> produk;
  const Pembelianproduk({Key? key, required this.produk}) : super(key: key);

  @override
  _PembelianprodukState createState() => _PembelianprodukState();
}

class _PembelianprodukState extends State<Pembelianproduk> {
  int JumlahProduk = 0;
  int Subtotal = 0;

  void updateJumlahProduk(int harga, int delta) {
    setState(() {
      JumlahProduk += delta;
      if (JumlahProduk < 0) JumlahProduk = 0;
      Subtotal = JumlahProduk * harga;
    });
  }

  Future<void> insertDetailPenjualan(int ProdukID, int PenjualanID, int JumlahProduk, int Subtotal) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase.from('detailpenjualan').insert({
        'ProdukID': ProdukID,
        'PenjualanID': PenjualanID,
        'JumlahProduk': JumlahProduk,
        'Subtotal': Subtotal,
      }).select();

      print('Response dari Supabase: $response'); // Debugging

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil disimpan!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan pesanan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final harga = produk['Harga'] ?? 0;
    final ProdukID = produk['ProdukID'] ?? 0;
    final PenjualanID = 1; 

    return Scaffold(
      appBar: AppBar(
        title: Text(
          produk['NamaProduk'] ?? 'Detail Produk',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(20),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk['NamaProduk'] ?? 'Nama Produk Tidak Tersedia',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text('Harga: Rp$harga', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  Text(
                    'Stok Tersedia: ${produk['Stok'] ?? 'Tidak Tersedia'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => updateJumlahProduk(harga, -1),
                        icon: const Icon(Icons.remove_circle, size: 32, color: Colors.brown),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$JumlahProduk',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () => updateJumlahProduk(harga, 1),
                        icon: const Icon(Icons.add_circle, size: 32, color: Colors.brown),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (JumlahProduk > 0) {
                              await insertDetailPenjualan(
                                ProdukID,
                                PenjualanID,
                                JumlahProduk,
                                Subtotal,
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => InsertProduk()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:Colors.brown[800],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Pesan (Rp$Subtotal)',
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
