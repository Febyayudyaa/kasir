import 'package:flutter/material.dart';
import 'package:kasirr/login.dart';
import 'package:kasirr/penjualan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}
