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

      await Supabase.instance.client.from('produk').update({
        'NamaProduk': _NamaProduk.text,
        'Harga': harga,  
        'Stok': stok,    
      }).eq('ProdukID', widget.ProdukID);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => menupage(title: 'Home Penjualan')), 
      );
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
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _Harga,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _Stok,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Masukkan angka yang valid untuk stok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateProduk,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[600], 
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.white), 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
