import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertProdukPage extends StatefulWidget {
  @override
  _InsertProdukPageState createState() => _InsertProdukPageState();
}

class _InsertProdukPageState extends State<InsertProdukPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    final nama = _namaController.text;
    final deskripsi = _deskripsiController.text;
    final harga = double.tryParse(_hargaController.text);
    final stok = int.tryParse(_stokController.text);

    if (harga == null || stok == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harga dan Stok harus valid!')),
      );
      return;
    }

    try {
      final response = await supabase.from('produk').insert({
        'NamaProduk': nama,
        'Deskripsi': deskripsi,
        'Harga': harga,
        'Stok': stok,
      }).select();

      if (response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil disimpan!')),
        );
        Navigator.pop(context, {
          'NamaProduk': nama,
          'Deskripsi': deskripsi,
          'Harga': harga,
          'Stok': stok,
        });
      } else {
        throw Exception('Gagal menyimpan data.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Produk'),
                validator: (value) => value == null || value.isEmpty ? 'Nama produk tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                validator: (value) => value == null || value.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  final parsedValue = double.tryParse(value);
                  if (parsedValue == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stokController,
                decoration: InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  final parsedValue = int.tryParse(value);
                  if (parsedValue == null) {
                    return 'Stok harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _saveData, child: Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
