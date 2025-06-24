import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_komplek/core/services/weather_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_komplek/presentation/home/screens/announcement_detail_screen.dart';
class BerandaTab extends StatefulWidget {
  const BerandaTab({super.key});

  @override
  State<BerandaTab> createState() => _BerandaTabState();
}

class _BerandaTabState extends State<BerandaTab> {

  // Tambahkan fungsi ini di dalam class _BerandaTabState
  void _panggilDarurat() async {
    final Uri url = Uri.parse('tel:112');
    if (!await launchUrl(url)) {
      // opsional: tambahkan notifikasi error jika gagal
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: 
            const EdgeInsets.fromLTRB(24, 60, 24, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var namaUser = (snapshot.data!.data() as Map<String, dynamic>)['nama'] ?? 'Warga';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Selamat Datang,", style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600])),
                        Text(namaUser, style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    );
                  }
                  return const SizedBox(height: 50);
                },
              ),
              FutureBuilder<Map<String, dynamic>>(
                  future: WeatherService().getCurrentWeather(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var weatherData = snapshot.data!;
                      var temperature = weatherData['main']['temp'].toStringAsFixed(0);
                      var weatherIconCode = weatherData['weather'][0]['icon'];
                      return Row(
                        children: [
                          Image.network('https://openweathermap.org/img/wn/$weatherIconCode@2x.png', width: 40, height: 40),
                          Text("$temperature°C", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      );
                    }
                    return const SizedBox(width: 40, height: 40, child: CircularProgressIndicator(strokeWidth: 2));
                  },
                ),
              ],
            ),),
            Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.call_outlined, color: Colors.white),
              label: Text("Panggil Bantuan Darurat", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade800,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _panggilDarurat,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Text("Pengumuman Terbaru", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('announcements').orderBy('timestamp', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                // Tampilan kosong yang sudah kita perbaiki
                return Center( /* ... Kode tampilan kosong Anda ... */ );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true, // WAJIB
                physics: const NeverScrollableScrollPhysics(), // WAJIB
                itemBuilder: (context, index) {
                  var pengumuman = snapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: ListTile(
                      title: Text(pengumuman['judul'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      subtitle: Text(pengumuman['isi'], maxLines: 2, overflow: TextOverflow.ellipsis),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AnnouncementDetailScreen(judul: pengumuman['judul'], isi: pengumuman['isi'])));
                      },
                    ),
                  );
                },
              );
            },
          ),

          ],
        ),
      ),
    );
  }
}