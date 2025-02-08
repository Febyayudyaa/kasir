import 'package:flutter/material.dart';
import 'package:kasirr/admin/registrasi/indexregistrasi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateRegistrasi extends StatefulWidget {
  final int id;

  const UpdateRegistrasi({super.key, required this.id});

  @override
  State<UpdateRegistrasi> createState() => _UpdateRegistrasiState();
}

class _UpdateRegistrasiState extends State<UpdateRegistrasi> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _role = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadRegistrasi();
  }

  Future<void> _loadRegistrasi() async {
    final data = await Supabase.instance.client
        .from('user')
        .select()
        .eq('id', widget.id)
        .single();

    setState(() {
      _username.text = data['username'] ?? '';
      _password.text = data['password'] ?? '';
      _role.text = data['role']?.toString() ?? '';
    });
  }

  Future<void> updateRegistrasi() async {
    if (_formKey.currentState!.validate()) {
      await Supabase.instance.client.from('user').update({
        'username': _username.text,
        'password': _password.text,
        'role': _role.text,
      }).eq('id',widget.id);

      Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => const IndexRegistrasi()),
        (route) => false, 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context, MaterialPageRoute(builder: (context) => IndexRegistrasi()));
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],  // Gradasi warna
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
                controller: _username,
                decoration: const InputDecoration(
                  labelText: 'username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                decoration: const InputDecoration(
                  labelText: 'password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _role,
                decoration: const InputDecoration(
                  labelText: 'role',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Role tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: updateRegistrasi,
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.brown[800],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
