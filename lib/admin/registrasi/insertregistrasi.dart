import 'package:flutter/material.dart';
import 'package:kasirr/admin/registrasi/indexregistrasi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertRegistrasi extends StatefulWidget {
  const InsertRegistrasi({super.key});

  @override
  State<InsertRegistrasi> createState() => _InsertRegistrasiState();
}

class _InsertRegistrasiState extends State<InsertRegistrasi> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text;
    final password = _passwordController.text;
    final role = _selectedRole;

    try {
      final response = await supabase.from('user').insert({
        'username': username,
        'password': password, 
        'role': role,
      }).select();

      if (response != null && response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan!')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const IndexRegistrasi()));
      } else {
        throw Exception('Gagal menyimpan data.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah User', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Colors.brown[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty
                    ? 'Password tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'role',
                  border: OutlineInputBorder(),
                ),
                items: ['Petugas', 'Admin']
                    .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedRole = value),
                validator: (value) => value == null || value.isEmpty
                    ? 'Role tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 20),
             ElevatedButton(
                onPressed: _saveData,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.brown[800],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
