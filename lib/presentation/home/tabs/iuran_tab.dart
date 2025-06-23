import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class IuranTab extends StatelessWidget {
  const IuranTab({super.key});

  void _launchWhatsApp(String namaUser) async {
  String nomorBendahara = "6287847611418"; // Nomor Bendahara
  String pesan = "Selamat pagi, saya $namaUser ingin konfirmasi pembayaran iuran. Berikut bukti transfernya.";
  final Uri url = Uri.parse('https://wa.me/$nomorBendahara?text=${Uri.encodeComponent(pesan)}');

  if (!await launchUrl(url)) {
    // Notifikasi eror 
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Status Iuran", style: GoogleFonts.poppins()),
      backgroundColor: Colors.white,
      elevation: 1,),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat data."));
          }
          
          if (snapshot.hasData && snapshot.data!.exists) {
            var userData = snapshot.data!.data();
            String nama = userData?['nama'] ?? 'Warga';
            var riwayatIuran = (userData?['riwayat_iuran'] as Map<String, dynamic>?) ?? {};

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Metode Pembayaran", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.account_balance),
                      title: Text("Bank BCA", style: GoogleFonts.poppins()),
                      subtitle: Text("1234-5678-90 a/n Bendahara Komplek", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text("Riwayat Pembayaran Anda", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  // if-else untuk menampilkan pesan riwayat kosong
                  riwayatIuran.isEmpty
                    ? const Text("Belum ada riwayat pembayaran.")
                    : Column(
                        // mengubah setiap data di Map menjadi sebuah widget Card
                        children: riwayatIuran.entries.map((entry) {
                          bool isLunas = entry.value == 'Lunas';
                          return Card(
                            color: isLunas ? Colors.green[50] : Colors.red[50],
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(entry.key), // "Juni 2025"
                              trailing: Text(
                                entry.value, // "Lunas"
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: isLunas ? Colors.green.shade800 : Colors.red.shade800,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  const SizedBox(height: 48),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                    label: Text("Konfirmasi via WhatsApp", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // panggil fungsi WhatsApp
                      _launchWhatsApp(nama); 
                    },
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text("Data iuran tidak ditemukan."));
        },
      ),
    );
  }
  }
