import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DetailPenjualanTab extends StatefulWidget {
  @override
  _DetailPenjualanTabState createState() => _DetailPenjualanTabState();
}

class _DetailPenjualanTabState extends State<DetailPenjualanTab> {
  List<Map<String, dynamic>> detailPenjualan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetailPenjualan();
  }

  Future<void> fetchDetailPenjualan() async {
    setState(() => isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('detailpenjualan')
          .select()
          .order('DetailID', ascending: true);

      setState(() {
        detailPenjualan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching detail penjualan: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteDetailPenjualan(int id) async {
    try {
      final response = await Supabase.instance.client
          .from('detailpenjualan')
          .delete()
          .eq('DetailID', id);

      if (response.error == null) {
        print('Detail penjualan dengan ID $id berhasil dihapus.');
        fetchDetailPenjualan();
      } else {
        print('Gagal menghapus detail penjualan: ${response.error!.message}');
      }
    } catch (e) {
      print('Error saat menghapus detail penjualan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Penjualan'),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                color: Colors.brown,
                size: 30,
              ),
            )
          : detailPenjualan.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada detail penjualan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: detailPenjualan.length,
                  itemBuilder: (context, index) {
                    final detail = detailPenjualan[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DetailID: ${detail['DetailID']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'PenjualanID: ${detail['PenjualanID']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ProdukID: ${detail['ProdukID']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Jumlah: ${detail['JumlahProduk']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Subtotal: ${detail['Subtotal']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.brown),
                                  onPressed: () {
                                    // Navigasi ke halaman update
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateDetailPage(
                                          detailID: detail['DetailID'],
                                        ),
                                      ),
                                    ).then((_) => fetchDetailPenjualan());
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.brown),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Hapus Detail Penjualan'),
                                          content: const Text(
                                              'Apakah Anda yakin ingin menghapus data ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteDetailPenjualan(
                                                    detail['DetailID']);
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
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InsertDetailPage()),
          );
          if (result == true) {
            fetchDetailPenjualan();
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
      ),
    );
  }
}

class InsertDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Detail Penjualan'),
      ),
      body: const Center(
        child: Text('Form Insert Detail Penjualan'),
      ),
    );
  }
}

class UpdateDetailPage extends StatelessWidget {
  final int detailID;

  UpdateDetailPage({required this.detailID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Detail Penjualan'),
      ),
      body: const Center(
        child: Text('Form Update Detail Penjualan'),
      ),
    );
  }
}
