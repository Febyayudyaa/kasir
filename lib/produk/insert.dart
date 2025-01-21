import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProdukPage extends StatefulWidget {
  const AddProdukPage({super.key});

  @override
  State<AddProdukPage> createState() => _AddProdukPageState();
}

class _AddProdukPageState extends State<AddProdukPage> {
  final _NamaProdukController = TextEditingController();
  final _HargaController = TextEditingController();
  final _StokController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _NamaProdukController.dispose();
    _HargaController.dispose();
    _StokController.dispose();
    super.dispose();
  }

  Future<void> tambahProduk() async {
    if (_formKey.currentState!.validate()) {
      final NamaProduk = _NamaProdukController.text.trim();
      final Harga = double.tryParse(_HargaController.text) ?? 0;
      final Stok = int.tryParse(_StokController.text) ?? 0;

      try {
        final response = await Supabase.instance.client
            .from('ProdukID')
            .insert([
              {
                'NamaProduk': NamaProduk,
                'Harga': Harga,
                'Stok': Stok,
              }
            ])
            .select()
            .single();

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produk berhasil ditambahkan!')),
          );
          Navigator.pop(context, true); 
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan produk: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _NamaProdukController,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama produk tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _HargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _StokController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Stok harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: tambahProduk,
                child: Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
