import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(
        title: Text("Profil Saya", style: GoogleFonts.poppins()),
        backgroundColor: Colors.white,
        elevation: 1,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_note_outlined),
              onPressed: () {
                // Untuk sekarang, tampilkan notifikasi bahwa fitur belum tersedia
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Fitur Edit Profil sedang dalam pengembangan."),
                    backgroundColor: Colors.indigo,
                  ),
                );
              },
            ),
          ],
        
        ),
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
          String noTelp = userData?['no_telp'] ?? 'Belum Diisi';
          String noKk = userData?['no_kk'] ?? 'Belum Diisi';
          String tglLahir = userData?['tgl_lahir'] ?? 'Belum Diisi';

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
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: Text("Nomor Telepon", style: GoogleFonts.poppins()),
                subtitle: Text(noTelp, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: Text("Nomor KK", style: GoogleFonts.poppins()),
                subtitle: Text(noKk, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text("Tanggal Lahir", style: GoogleFonts.poppins()),
                subtitle: Text(tglLahir, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Konfirmasi Logout", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                        content: Text("Apakah Anda yakin ingin keluar dari akun Anda?", style: GoogleFonts.poppins()),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Batal", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                            onPressed: () {
                              // Tutup dialog
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("Yakin", style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              // Proses Logout dari Firebase
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
                    },
                  );
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