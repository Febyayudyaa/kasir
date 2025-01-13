import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: MyHomePage(title: 'Home Penjualan'),
  ));
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedOrderType;
  bool isMakananVisible = false;
  Map<String, int> cart = {}; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.grid_view), onPressed: () {}),
          IconButton(icon: Icon(Icons.zoom_out_map), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Semua', 'Makanan', 'Minuman', 'Customer']
                  .map((label) => _buildCategoryButton(label))
                  .toList(),
            ),
          ),
          Visibility(
            visible: isMakananVisible,
            child: Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8, 
                ),
                itemCount: 5, 
                itemBuilder: (context, index) {
                  String name;
                  String imagePath;
                  switch (index) {
                    case 0:
                      name = 'Choco Chip Cookies';
                      imagePath = 'asset/image/choco.jpg';
                      break;
                    case 1:
                      name = 'Oatmeal Raisin Cookies';
                      imagePath = 'asset/image/otml.jpg';
                      break;
                    case 2:
                      name = 'Birthday Cake Cookies';
                      imagePath = 'asset/image/bckjpg.jpg';
                      break;
                    case 3:
                      name = 'Red Velvet Cookies';
                      imagePath = 'asset/image/rdvjpg.jpg';
                      break;
                    case 4:
                      name = 'Matcha Cookies';
                      imagePath = 'asset/image/mtcha.jpg';
                      break;
                    default:
                      name = 'Unknown';
                      imagePath = '';
                  }

                  return _buildCategoryItem(name, imagePath);
                },
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
                    IconButton(icon: Icon(Icons.person), onPressed: () {}),
                  ],
                ),
                Text('2 Barang = Rp'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton _buildCategoryButton(String label) {
    return ElevatedButton(
      onPressed: () {
        if (label == 'Makanan') {
          setState(() {
            isMakananVisible = !isMakananVisible;
          });
        }
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[800]),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryItem(String name, String imagePath) {
    return GestureDetector(
      onTap: () {
        _showQuantityDialog(name);
      },
      child: Card(
        color: Colors.brown[100],
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(imagePath, fit: BoxFit.cover), 
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuantityDialog(String productName) {
    int quantity = cart[productName] ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pilih Jumlah untuk $productName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Jumlah yang ingin dibeli:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (quantity > 0) {
                        setState(() {
                          cart[productName] = quantity - 1;
                        });
                      }
                    },
                  ),
                  Text(quantity.toString()),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        cart[productName] = quantity + 1;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Tutup'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  if (quantity > 0) {
                    cart[productName] = quantity;
                  }
                });
              },
              child: Text('Tambahkan ke Keranjang'),
            ),
          ],
        );
      },
    );
  }
}
