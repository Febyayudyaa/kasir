import 'package:flutter/material.dart';
import 'package:kasirr/petugas/homepenjualan.dart';
import 'package:kasirr/petugas/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateProduk extends StatefulWidget {
  final int ProdukID;

  const UpdateProduk({super.key, required this.ProdukID});

  @override
  State<UpdateProduk> createState() => _UpdateProdukState();
}

class _UpdateProdukState extends State<UpdateProduk> {
  final _nmprdk = TextEditingController();
  final _harga = TextEditingController();
  final _stok = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProduklangganData();
  }

  // Fungsi untuk memuat data produk berdasarkan ID
  Future<void> _loadProduklangganData() async {
    final data = await Supabase.instance.client
        .from('produk')
        .select()
        .eq('ProdukID', widget.ProdukID)
        .single();

    setState(() {
      _nmprdk.text = data['NamaProduk'] ?? '';
      _harga.text = data['Harga']?.toString() ?? '';
      _stok.text = data['Stok']?.toString() ?? '';
    });
  }

  Future<void> updateProduklanggan() async {
    if (_formKey.currentState!.validate()) {
      await Supabase.instance.client.from('produk').update({
        'NamaProduk': _nmprdk.text,
        'Harga': _harga.text,
        'Stok': _stok.text,
      }).eq('ProdukID', widget.ProdukID);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false, 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Produk', style: TextStyle(color: Colors.white)),
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nmprdk,
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
                controller: _harga,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stok,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                 const  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: updateProduklanggan,
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color(0xFFFA7070),
                    ),
                  )
                ],
              )            ],
          ),
        ),
      ),
    );
  }
}