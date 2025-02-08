import 'package:flutter/material.dart';
import 'package:kasirr/admin/home_admin.dart';
import 'package:kasirr/admin/pelanggan/insert.dart';
import 'package:kasirr/admin/pelanggan/update.dart';
import 'package:kasirr/homepenjualan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PelangganTab extends StatefulWidget {
  @override
  _PelangganTabState createState() => _PelangganTabState();
}

class _PelangganTabState extends State<PelangganTab> {
  List<Map<String, dynamic>> pelanggan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching pelanggan: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletePelanggan(int? id) async {
    if (id == null) return;
    try {
      await Supabase.instance.client.from('pelanggan').delete().eq('PelangganID', id);
      // Perbarui daftar pelanggan setelah penghapusan
      fetchPelanggan();
    } catch (e) {
      print('Error deleting pelanggan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pelanggan'),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeAdmin())
            );
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                color: Colors.brown,
                size: 30,
              ),
            )
          : pelanggan.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada pelanggan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: pelanggan.length,
                  itemBuilder: (context, index) {
                    final langgan = pelanggan[index];
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
                              langgan['NamaPelanggan'] ?? 'Pelanggan tidak tersedia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              langgan['Alamat'] ?? 'Alamat tidak tersedia',
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            SizedBox(height: 4),
                            Text(
                              langgan['NomorTelepon'] ?? 'Tidak tersedia',
                              style: TextStyle(fontSize: 14),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Color(0xFF8D6E63)),
                                  onPressed: () {
                                    final pelangganID = langgan['PelangganID'] as int?;
                                    if (pelangganID != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditPelanggan(PelangganID: pelangganID),
                                        ),
                                      ).then((value) {
                                        if (value == true) {
                                          fetchPelanggan(); // Memperbarui daftar pelanggan
                                        }
                                      });
                                    } else {
                                      print('ID pelanggan tidak valid');
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Color(0xFF8D6E63)),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Hapus Pelanggan'),
                                          content: Text(
                                              'Apakah Anda yakin ingin menghapus pelanggan ini?'),
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
                                                    deletePelanggan(langgan['PelangganID']);
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
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Setelah pelanggan baru ditambahkan, perbarui daftar pelanggan tanpa perlu kembali ke halaman utama
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InsertPelangganPage()),
          );
          fetchPelanggan(); 
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
      ),
    );
  }
}
