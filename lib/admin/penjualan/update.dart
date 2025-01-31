import 'package:flutter/material.dart';
import 'package:kasirr/admin/penjualan/index.dart';
import 'package:kasirr/petugas/homepenjualan.dart';
import 'package:kasirr/petugas/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdatePenjualan extends StatefulWidget {
  final int PenjualanID;

  const UpdatePenjualan({super.key, required this.PenjualanID});

  @override
  State<UpdatePenjualan> createState() => _UpdatePenjualanState();
}

class _UpdatePenjualanState extends State<UpdatePenjualan> {
  final _tgl = TextEditingController();
  final _total = TextEditingController();
  final _plnggnId = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadPenjualan();
  }

  Future<void> _loadPenjualan() async {
    final data = await Supabase.instance.client
        .from('penjualan')
        .select()
        .eq('PenjualanID', widget.PenjualanID)
        .single();

    setState(() {
      _tgl.text = data['TanggalPenjualan'] ?? '';
      _total.text = data['TotalHarga'] ?? '';
      _plnggnId.text = data['PelangganID']?.toString() ?? '';
    });
  }

  Future<void> updatePenjualan() async {
    if (_formKey.currentState!.validate()) {
      // Melakukan update data penjualan ke database
      await Supabase.instance.client.from('penjualan').update({
        'TanggalPenjualan': _tgl.text,
        'TotalHarga': _total.text,
        'PelangganID': _plnggnId.text,
      }).eq('PenjualanID', widget.PenjualanID);

      Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Penjualan', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4E342E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, MaterialPageRoute(builder: (context) => const IndexPenjualan()));
          },
        ),
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
                controller: _tgl,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Penjualan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _total,
                decoration: const InputDecoration(
                  labelText: 'Total Harga',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Total tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plnggnId,
                decoration: const InputDecoration(
                  labelText: 'ID Pelanggan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ID tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: updatePenjualan,
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.brown,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}