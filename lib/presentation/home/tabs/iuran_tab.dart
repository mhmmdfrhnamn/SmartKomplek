import 'package:flutter/material.dart';

class IuranTab extends StatelessWidget {
  const IuranTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Status Iuran")),
      body: const Center(child: Text("Konten Status Iuran akan ada disini"),),
    );
  }
}