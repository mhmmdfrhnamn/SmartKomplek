import 'package:flutter/material.dart';

class ProfilTab extends StatelessWidget {
  const ProfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Saya")),
      body: const Center(child: Text("Konten Profil dan Tombol Logout ada disini")),
    );
  }
}