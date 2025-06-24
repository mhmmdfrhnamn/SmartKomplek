import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final String judul;
  final String isi;

  const AnnouncementDetailScreen({
    super.key,
    required this.judul,
    required this.isi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Pengumuman", style: GoogleFonts.poppins()),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan judul pengumuman
            Text(
              judul,
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Anda bisa tambahkan info tanggal/penulis di sini jika ada
            const Divider(thickness: 1, height: 32),
            Text(
              isi,
              style: GoogleFonts.poppins(fontSize: 16, height: 1.5), 
            ),
          ],
        ),
      ),
    );
  }
}