import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Beranda")),
      body: StreamBuilder<QuerySnapshot>(
      
      stream: FirebaseFirestore.instance.collection('announcements').orderBy('timestamp', descending: true).snapshots(),

      builder: (context, snapshot) {
        // Jika statusnya masih menunggu data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Jika stream tidak punya data atau datanya kosong
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Belum ada pengumuman."));
        }

        // Jika ada error
        if (snapshot.hasError) {
          return const Center(child: Text("Terjadi kesalahan."));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            // Ambil satu dokumen pengumuman
            var pengumuman = snapshot.data!.docs[index];
            String judul = pengumuman['judul'];
            String isi = pengumuman['isi'];

            // Tampilkan dalam Card
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(judul, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(isi, maxLines: 3, overflow: TextOverflow.ellipsis),
                ),
                onTap: () {
                  // Nanti bisa dibuat halaman detail jika di-klik
                },
              ),
            );
          },
        );
      },
    ),
    );
  }
}