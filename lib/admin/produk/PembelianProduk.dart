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
      });

      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil disimpan!')),
        );
        Navigator.pop(context);
      } else {
        throw response.error!;
      }
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
    final PenjualanID = 1; // Placeholder untuk ID penjualan

    return Scaffold(
      appBar: AppBar(
        title: Text(
          produk['NamaProduk'] ?? 'Detail Produk',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFA7070),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF6D4C41), Color(0xFF8D6E63), Color(0xFFA1887F)], 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
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
                        icon: const Icon(Icons.remove_circle, size: 32, color: Colors.red),
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
                        icon: const Icon(Icons.add_circle, size: 32, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: JumlahProduk > 0
                              ? () async {
                                  await insertDetailPenjualan(
                                    ProdukID,
                                    PenjualanID,
                                    JumlahProduk,
                                    Subtotal,
                                  );
                                } : () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => InsertProduk()));
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFA7070),
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