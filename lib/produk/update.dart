import 'package:flutter/material.dart';
import 'package:kasirr/homepenjualan.dart';
import 'package:kasirr/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Produk {
  String produkID;
  String nama;
  double harga;
  int stok;

  Produk({
    required this.produkID,
    required this.nama,
    required this.harga,
    required this.stok,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      produkID: json['ProdukID'],
      nama: json['NamaProduk'],
      harga: json['Harga'].toDouble(),
      stok: json['Stok'],
    );
  }
}

class UpdateProdukPage extends StatelessWidget {
  final Produk produk;

  UpdateProdukPage({required this.produk});
  
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    _namaController.text = produk.nama;
    _hargaController.text = produk.harga.toString();
    _stokController.text = produk.stok.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Produk'),
        backgroundColor: Colors.brown[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama Produk'),
            ),
            TextField(
              controller: _hargaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Harga Produk'),
            ),
            TextField(
              controller: _stokController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Stok Produk'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final nama = _namaController.text;
                final harga = double.tryParse(_hargaController.text);
                final stok = int.tryParse(_stokController.text);

                if (nama.isNotEmpty && harga != null && stok != null) {
                  try {
                    final response = await supabase.from('produk').update({
                      'NamaProduk': nama,
                      'Harga': harga,
                      'Stok': stok,
                    }).eq('ProdukID', produk.produkID);

                    if (response.error == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Produk berhasil diperbarui!')),
                      );
                      Navigator.pop(context);
                    } else {
                      throw Exception('Gagal memperbarui produk.');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Terjadi kesalahan: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mohon lengkapi semua data dengan benar!')),
                  );
                }
              },
              child: Text('Update Produk'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[800]),
            ),
          ],
        ),
      ),
    );
  }
}
