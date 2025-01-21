import 'package:flutter/material.dart';
import 'package:kasirr/homepenjualan.dart';
import 'package:kasirr/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class UpdateProdukPage extends StatefulWidget {
  final int ProdukID;
  const UpdateProdukPage({super.key, required this.ProdukID});

  @override
  State<UpdateProdukPage> createState() => _UpdateProdukPageState();
}

class _UpdateProdukPageState extends State<UpdateProdukPage> {
  final _NamaProduk = TextEditingController();
  final _Harga = TextEditingController();
  final _Stok = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
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
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

    Future<void> updateProduk() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await Supabase.instance.client.from('produk').update({
          'NamaProduk': _NamaProduk.text,
          'Harga': double.tryParse(_Harga.text) ?? 0,
          'Stok': int.tryParse(_Stok.text) ?? 0,
        }).eq('ProdukID', widget.ProdukID);

        if (response.error == null) {
          Navigator.pop(context, true); 
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.error!.message}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Produk')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _NamaProduk,
                decoration: InputDecoration(labelText: 'Nama Produk'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama produk tidak boleh kosong' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _Harga,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _Stok,
                decoration: InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateProduk,
                child: Text('Update Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
