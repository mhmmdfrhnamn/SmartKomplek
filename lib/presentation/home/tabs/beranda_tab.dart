import 'package:flutter/material.dart';

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Beranda")),
      body: const Center(child: Text("Konten Pengumuman akan ada disini")),
    );
  }
}