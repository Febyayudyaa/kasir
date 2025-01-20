import 'package:flutter/material.dart';
import 'insert.dart';
import 'package:kasirr/produk/update.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Produk {
  String ProdukID;
  String NamaProduk;
  double Harga;
  int Stok;

  Produk({
    required this.ProdukID,
    required this.NamaProduk,
    required this.Harga,
    required this.Stok,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      ProdukID: json['ProdukID'].toString(),
      NamaProduk: json['NamaProduk'],
      Harga: (json['Harga'] as num).toDouble(),
      Stok: json['Stok'] as int,
    );
  }
}

class ProdukTab extends StatefulWidget {
  @override
  _ProdukTabState createState() => _ProdukTabState();
}

class _ProdukTabState extends State<ProdukTab> {
  List<Produk> produkList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
  setState(() {
    isLoading = true;
  });
  try {
    final response = await Supabase.instance.client.from('produk').select().execute();
    if (response.error == null && response.data != null) {
      setState(() {
        produkList = (response.data as List)
            .map((item) => Produk.fromJson(item))
            .toList();
      });
    } else {
      print('Error fetching produk: ${response.error?.message}');
    }
  } catch (e) {
    print('Error fetching produk: $e');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  Future<void> deleteProduk(String ProdukID) async {
    try {
      final response = await Supabase.instance.client
          .from('produk')
          .delete()
          .eq('ProdukID', ProdukID);

      if (response.error == null) {
        fetchProduk();  // Refresh the list after deletion
      } else {
        print('Error deleting produk: ${response.error?.message}');
      }
    } catch (e) {
      print('Error deleting produk: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Produk'),
        backgroundColor: Colors.brown[800],
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.twoRotatingArc(color: Colors.brown, size: 30),
            )
          : produkList.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: produkList.length,
                  itemBuilder: (context, index) {
                    final produk = produkList[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              produk.NamaProduk,
                              style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Harga: Rp ${produk.Harga} | Stok: ${produk.Stok}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Color(0xFF8D6E63)),
                                  onPressed: () {
                                    final produk = produkList[index];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateProdukPage(produk: produk),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Color(0xFF8D6E63)),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Hapus Produk'),
                                          content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteProduk(produk.ProdukID);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Hapus'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InsertProdukPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.brown[600],
        foregroundColor: Colors.white,
      ),
    );
  }
}
