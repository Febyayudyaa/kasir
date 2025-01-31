import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IndexDetailJual extends StatefulWidget {
  final Map<String, dynamic> prd;
  const IndexDetailJual({Key? key, required this.prd}) : super(key: key);

  @override
  State<IndexDetailJual> createState() => _IndexDetailJualState();
}

class _IndexDetailJualState extends State<IndexDetailJual> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> detailpenjualan = [];

  @override
  void initState() {
    super.initState();
    fetchDetailPenjualan();
  }

  Future<void> fetchDetailPenjualan() async {
    try {
      final response = await supabase.from('detailpenjualan').select();
      setState(() {
        detailpenjualan = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching detail penjualan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D4C41), Color(0xFF8D6E63), Color(0xFFA1887F)], 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: detailpenjualan.length,
          itemBuilder: (context, index) {
            final detail = detailpenjualan[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,  // Merapikan teks
                    children: [
                      Row(
                        children: [
                          Text('Detail ID: ${detail['DetailID']?.toString() ?? 'tidak tersedia'}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 28),
                          Text('Penjualan ID: ${detail['PenjualanID']?.toString() ?? 'tidak tersedia'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 28),
                          Text('Produk ID: ${detail['ProdukID']?.toString() ?? 'tidak tersedia'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 28),
                          Text('Jumlah Produk: ${detail['JumlahProduk']?.toString() ?? 'tidak tersedia'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 28),
                          Text('Subtotal: ${detail['Subtotal']?.toString() ?? 'tidak tersedia'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}