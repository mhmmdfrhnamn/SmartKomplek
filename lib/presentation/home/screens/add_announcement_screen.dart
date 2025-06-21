import 'package:flutter/material.dart';

class AddAnnouncementScreen extends StatelessWidget {
  const AddAnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Pengumuman Baru")),
      body: const Center(child: Text("Form untuk membuat pengumuman akan ada disini")),
    );
  }
}