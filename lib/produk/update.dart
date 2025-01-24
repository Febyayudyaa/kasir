import 'package:flutter/material.dart';
import 'package:kasirr/homepenjualan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProduk extends StatefulWidget {
  final int ProdukID;

  const EditProduk({super.key, required this.ProdukID});

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final _NamaProduk = TextEditingController();
  final _Harga = TextEditingController();
  final _Stok = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProdukData();
  }

  Future<void> _loadProdukData() async {
    try {
      final data = await Supabase.instance.client
          .from('produk')
          .select()
          .eq('ProdukID', widget.ProdukID)
          .single();

      setState(() {
        _NamaProduk.text = data['NamaProduk'] ?? '';
        _Harga.text = data['Harga']?.toString() ?? '';
        _Stok.text = data['Stok']?.toString() ?? '';   
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateProduk() async {
    if (_formKey.currentState!.validate()) {
      double? harga = double.tryParse(_Harga.text);
      int? stok = int.tryParse(_Stok.text);

      if (harga == null || stok == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Harga atau Stok tidak valid')),
        );
        return;
      }

      try {
        await Supabase.instance.client.from('produk').update({
          'NamaProduk': _NamaProduk.text,
          'Harga': harga,
          'Stok': stok,
        }).eq('ProdukID', widget.ProdukID);

        Navigator.pop(context, true); // Kembali setelah update produk
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengupdate produk')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _NamaProduk,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _Harga,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan harga yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _Stok,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Masukkan stok yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateProduk,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
