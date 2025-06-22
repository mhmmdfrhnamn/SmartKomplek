import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddAnnouncementScreen extends StatefulWidget {
  const AddAnnouncementScreen({super.key});

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final _judulController = TextEditingController();
  final _isiController = TextEditingController();
  bool _isLoading = false;

  void _kirimPengumuman() async {
    // Validasi 
    if (_judulController.text.isNotEmpty && _isiController.text.isNotEmpty) {
      setState(() {
        _isLoading = true; 
      });

      try {
        // Simpan ke Firestore
        await FirebaseFirestore.instance.collection('announcements').add({
          'judul': _judulController.text.trim(),
          'isi': _isiController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(), // Otomatis mengisi waktu server
          'authorId': FirebaseAuth.instance.currentUser?.uid, // Menyimpan ID 
        });

        if (mounted) {
          // notifikasi sukses
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Pengumuman berhasil dikirim!"), backgroundColor: Colors.green),
          );
          Navigator.pop(context); // Kembali ke hal utama
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal mengirim: $e"), backgroundColor: Colors.red),
          );
        }
      }
    } else {
      // Tampilkan error jika ada field yang kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul dan Isi tidak boleh kosong."), backgroundColor: Colors.orange),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Pengumuman Baru")),
      body: ListView(
  padding: const EdgeInsets.all(24.0),
  children: [
    TextField(
      controller: _judulController,
      decoration: const InputDecoration(labelText: "Judul Pengumuman"),
      textCapitalization: TextCapitalization.sentences, // Huruf pertama kapital
    ),
    const SizedBox(height: 16),
    TextField(
      controller: _isiController,
      decoration: const InputDecoration(labelText: "Isi Pengumuman"),
      maxLines: 8, // Membuat field lebih besar
      textCapitalization: TextCapitalization.sentences,
    ),
    const SizedBox(height: 24),
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        minimumSize: const Size.fromHeight(55),
      ),
      // Logika onPressed 
      onPressed: _isLoading ? null : _kirimPengumuman, 
      child: _isLoading 
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text("KIRIM PENGUMUMAN", style: TextStyle(color: Colors.white)),
    ),
  ],
),
    );
  }
}