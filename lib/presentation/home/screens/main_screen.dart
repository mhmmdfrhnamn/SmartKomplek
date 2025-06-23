import 'package:flutter/material.dart';
import 'package:smart_komplek/presentation/home/screens/add_announcement_screen.dart';
import 'package:smart_komplek/presentation/home/tabs/beranda_tab.dart';
import 'package:smart_komplek/presentation/home/tabs/iuran_tab.dart';
import 'package:smart_komplek/presentation/home/tabs/profil_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Variabel untuk menyimpan index yang aktif
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BerandaTab(),
    const IuranTab(),
    const ProfilTab(),
  ];

  // Fungsi yang akan dipanggil saat tab di klik
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Ambil ID user yang sedang login
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return StreamBuilder<DocumentSnapshot>(
      // Stream ini "berlangganan" pada data DOKUMEN user yang sedang login
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        
        // Defaultnya, anggap pengguna adalah warga biasa
        String userRole = 'warga';

        // Jika data sudah ada dan valid dari Firestore
        if (snapshot.hasData && snapshot.data!.exists) {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          // Ambil nilai 'role' dari data. Jika tidak ada, tetap 'warga'.
          userRole = data['role'] ?? 'warga';
        }

        // Sekarang kita bangun Scaffold-nya, sama seperti sebelumnya
        return Scaffold(
          body: _pages[_selectedIndex],

          // --- INI BAGIAN AJAIBNYA ---
          // Kita gunakan if-else sederhana (ternary operator)
          // Jika userRole adalah 'admin', tampilkan FloatingActionButton.
          // Jika tidak, tampilkan null (tidak ada tombol).
          floatingActionButton: userRole == 'admin'
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddAnnouncementScreen()),
                    );
                  },
                  backgroundColor: Colors.indigo,
                  child: const Icon(Icons.add, color: Colors.white),
                )
              : null,
          
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long_outlined),
                  activeIcon: Icon(Icons.receipt_long),
                  label: 'Iuran',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Colors.indigo,
              unselectedItemColor: Colors.grey[600],
            ),
          ),
        );
      }
    );
  }
}