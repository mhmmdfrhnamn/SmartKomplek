import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class IuranTab extends StatelessWidget {
  const IuranTab({super.key});

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
            return const Center(child: Text("Gagal memuat data iuran."));
          }
          
          if (snapshot.hasData && snapshot.data!.exists) {
            var userData = snapshot.data!.data();
            String nama = userData?['nama'] ?? 'Warga';
            String statusIuran = userData?['status_iuran_juni'] ?? 'Belum terdata';
            Color statusColor = statusIuran == 'Lunas' ? Colors.green.shade700 : Colors.red.shade700;

            return Center(
              child: Card(
                margin: const EdgeInsets.all(24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Bulan Juni 2025", style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[700])),
                      const SizedBox(height: 8),
                      Text(nama, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          statusIuran.toUpperCase(),
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          
          return const Center(child: Text("Data iuran tidak ditemukan."));
        },
      ),
    );
  }
  }
