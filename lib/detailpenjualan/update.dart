import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateDetailPage extends StatefulWidget {
  final int detailID;

  UpdateDetailPage({required this.detailID});

  @override
  _UpdateDetailPageState createState() => _UpdateDetailPageState();
}

class _UpdateDetailPageState extends State<UpdateDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _penjualanIDController = TextEditingController();
  final _produkIDController = TextEditingController();
  final _jumlahProdukController = TextEditingController();
  final _subtotalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDetailData();
  }

  Future<void> _loadDetailData() async {
    try {
      final response = await Supabase.instance.client
          .from('detailpenjualan')
          .select()
          .eq('DetailID', widget.detailID)
          .single();

      setState(() {
        _penjualanIDController.text = response['PenjualanID'].toString();
        _produkIDController.text = response['ProdukID'].toString();
        _jumlahProdukController.text = response['JumlahProduk'].toString();
        _subtotalController.text = response['Subtotal'].toString();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $error')),
      );
    }
  }

  Future<void> updateDetailPenjualan() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await Supabase.instance.client
            .from('detailpenjualan')
            .update({
              'PenjualanID': int.parse(_penjualanIDController.text),
              'ProdukID': int.parse(_produkIDController.text),
              'JumlahProduk': int.parse(_jumlahProdukController.text),
              'Subtotal': double.parse(_subtotalController.text),
            })
            .eq('DetailID', widget.detailID);

        if (response != null) {
          Navigator.pop(context, true); // Indikasi berhasil
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui data!')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Detail Penjualan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _penjualanIDController,
                decoration: const InputDecoration(
                  labelText: 'Penjualan ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Penjualan ID tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _produkIDController,
                decoration: const InputDecoration(
                  labelText: 'Produk ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Produk ID tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahProdukController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Produk',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah Produk tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subtotalController,
                decoration: const InputDecoration(
                  labelText: 'Subtotal',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Subtotal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateDetailPenjualan,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
