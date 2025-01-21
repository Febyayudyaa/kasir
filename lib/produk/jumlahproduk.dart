import 'package:flutter/material.dart';

class JumlahProdukPage extends StatefulWidget {
  final Map<String, dynamic> produk;

  const JumlahProdukPage({Key? key, required this.produk}) : super(key: key);

  @override
  _JumlahProdukPageState createState() => _JumlahProdukPageState();
}

class _JumlahProdukPageState extends State<JumlahProdukPage> {
  int jumlah = 1;

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final stok = produk['Stok'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Jumlah Produk'),
        backgroundColor: Colors.brown[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Produk: ${produk['NamaProduk']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Harga: ${produk['Harga']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Stok Tersedia: $stok',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.brown[800]),
                  onPressed: () {
                    if (jumlah > 1) {
                      setState(() {
                        jumlah--;
                      });
                    }
                  },
                ),
                Text(
                  '$jumlah',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.brown[800]),
                  onPressed: () {
                    if (jumlah < stok) {
                      setState(() {
                        jumlah++;
                      });
                    }
                  },
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, jumlah);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[800],
                foregroundColor: Colors.white,
              ),
              child: Text('Tambahkan ke Keranjang'),
            ),
          ],
        ),
      ),
    );
  }
}
