import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';
import 'register.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ejsimgpbrinksndwaann.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqc2ltZ3Bicmlua3NuZHdhYW5uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYzMzU0MTgsImV4cCI6MjA1MTkxMTQxOH0.99-o0u0wykWd3vSO_7kp6nDgKg3zFmvMDWFgzSQnNmw',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: HomePage(), 
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6D4C41),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('asset/image/Untitled_design__1_-removebg-preview (1).png'),
            SizedBox(height: 40),
            Text(
              'WELCOME',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFF2D2D30),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _buildButton(context, 'Login', LoginPage()),
                  SizedBox(height: 20),
                  _buildButton(context, 'Register', RegisterPage()),  // Perhatikan di sini, RegisterPage dipanggil
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Widget page) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),  // Navigasi ke RegisterPage atau LoginPage
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown[800],
          padding: EdgeInsets.symmetric(vertical: 16),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
