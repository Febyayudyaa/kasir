import 'package:flutter/material.dart';
import 'package:kasirr/homepenjualan.dart';

class HomePetugas extends StatefulWidget {
  const HomePetugas({super.key});

  @override
  State<HomePetugas> createState() => _HomePetugasState();
}

class _HomePetugasState extends State<HomePetugas> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MenuPage(title: "Beranda Petugas", isPetugas: true), 
    );
  }
}
