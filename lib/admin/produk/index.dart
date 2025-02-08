import 'package:flutter/material.dart';
import 'package:kasirr/admin/home_admin.dart';
import 'package:kasirr/admin/produk/insert.dart';
import 'package:kasirr/admin/produk/Pembelianproduk.dart';
import 'package:kasirr/admin/produk/update.dart';
import 'package:kasirr/homepenjualan.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';

class IndexProduk extends StatefulWidget {
  final bool showFAB;

  const IndexProduk({Key? key, this.showFAB = true}) : super(key: key);

  @override
  _IndexProdukState createState() => _IndexProdukState();
}

class _IndexProdukState extends State<IndexProduk> {
  List<Map<String, dynamic>> produk = [];

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching produk: $e');
    }
  }

  Future<void> deleteProduk(int id) async {
    try {
      await Supabase.instance.client.from('produk').delete().eq('ProdukID', id);
      fetchProduk();
    } catch (e) {
      print('Error deleting produk: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeAdmin())); 
          }, 
        ),
        title: const Text(
          'Menu Produk',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.white,  
        child: produk.isEmpty
            ? const Center(
                child: Text(
                  'Tidak ada produk',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,  
                  ),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1 / 1,
                ),
                itemCount: produk.length,
                itemBuilder: (context, index) {
                  final langgan = produk[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Pembelianproduk(produk: langgan)),
                      );
                    },
                    child: Container(
                      width: 160,  
                      height: 200, 
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                langgan['NamaProduk'] ?? 'Produk tidak tersedia',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Harga: ${langgan['Harga'] ?? 'Tidak tersedia'}',
                                style: const TextStyle(
                                  fontWeight:  FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.brown,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Stok: ${langgan['Stok'] ?? 'Tidak tersedia'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (widget.showFAB)
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.brown),
                                      onPressed: () {
                                        final ProdukID = langgan['ProdukID'] ?? 0;
                                        if (ProdukID != 0) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UpdateProduk(ProdukID: ProdukID),
                                            ),
                                          );
                                        } else {
                                          print('ID produk tidak valid');
                                        }
                                      },
                                    ),
                                  if (widget.showFAB)
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.brown),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Hapus Produk'),
                                              content: const Text(
                                                  'Apakah Anda yakin ingin menghapus produk ini?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors.grey[300], // Warna abu-abu untuk Batal
                                                  ),
                                                  child: const Text(
                                                    'Batal',
                                                    style: TextStyle(color: Colors.black), // Teks hitam
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deleteProduk(langgan['ProdukID']);
                                                    Navigator.pop(context);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors.brown[800], // Warna merah untuk Hapus
                                                  ),
                                                  child: const Text(
                                                    'Hapus',
                                                    style: TextStyle(color: Colors.white), // Teks putih
                                                  ),
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
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: widget.showFAB
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InsertProduk()));
              },
              backgroundColor: Colors.brown[800],
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
