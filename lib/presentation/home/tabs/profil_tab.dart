import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_komplek/presentation/auth/screens/login_screen.dart';

class ProfilTab extends StatefulWidget {
  const ProfilTab({super.key});

  @override
  State<ProfilTab> createState() => _ProfilTabState();
}

class _ProfilTabState extends State<ProfilTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Saya")),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      // mengambil data DOKUMEN user yang sedang login
      future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (context, snapshot) {
        // Jika masih loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Jika ada error
        if (snapshot.hasError) {
          return const Center(child: Text("Tidak bisa memuat data."));
        }

        // Jika data berhasil didapat
        if (snapshot.hasData) {
          // Ambil data dari snapshot
          var userData = snapshot.data!.data();
          String nama = userData?['nama'] ?? 'Nama Tidak Ditemukan';
          String email = userData?['email'] ?? 'Email Tidak Ditemukan';

          // Tampilkan dalam sebuah layout
          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text("Nama Lengkap"),
                subtitle: Text(nama, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text("Email"),
                subtitle: Text(email, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              const SizedBox(height: 48),
              // Tombol Logout
              ElevatedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text("LOGOUT", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (mounted) {
                    // Kembali ke halaman login dan hapus semua halaman sebelumnya
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
              ),
            ],
          );
        }

        // Tampilan default jika terjadi sesuatu
        return const Center(child: Text("Memuat profil..."));
      },
    ),
    );
  }
}