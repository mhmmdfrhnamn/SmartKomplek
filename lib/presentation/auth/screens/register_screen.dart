import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_komplek/presentation/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_komplek/presentation/home/screens/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.home_work_outlined,
                  size: 80,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 40,),

                Text(
                  "Buat Akun Baru",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Daftar untuk melanjutkan",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 48,),

                // Form Input

                // Nama Lengkap
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Nama Lengkap",
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                // Tombol Login
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (_isLoading = true) return;
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      // Buat user baru dengan Firebase Auth
                      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _emailController.text, 
                        password: _passwordController.text,);

                      // Jika berhasil, simpat data user ke firestore
                      await FirebaseFirestore.instance.collection("users").doc(credential.user!.uid).set({
                        'nama': _nameController.text,
                        'email': _emailController.text,
                        'role': 'warga',
                        'status_iuran': 'Belum Lunas',
                      });

                      // Pindah ke hal utama
                      if (mounted) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MainScreen()));
                      }
                    } on FirebaseAuthException catch (e) {
                      // Tampilkan pesan error jika gagal
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Firebase Auth Error ${e.message}"),
                        backgroundColor: Colors.red,
                      ));
                    } finally {
                      if(mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)
                  : Text(
                    "Daftar",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height:16),

                // Navigasi ke Hal Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sudah Punya Akun", style: GoogleFonts.poppins()),
                    TextButton(
                      onPressed: () {
                        // Push ke loginscreen
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()),);
                      },
                      child: Text(
                        "Login Disini",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color:Colors.indigo),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}