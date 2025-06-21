import 'package:flutter/material.dart';
import 'package:smart_komplek/presentation/home/screens/add_announcement_screen.dart';
import 'package:smart_komplek/presentation/home/tabs/beranda_tab.dart';
import 'package:smart_komplek/presentation/home/tabs/iuran_tab.dart';
import 'package:smart_komplek/presentation/home/tabs/profil_tab.dart';

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
    return Scaffold(
      // body akan menampilkan halaman sesuai tab yang aktif
      body: _pages[_selectedIndex],

      // tombol floating action
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
          MaterialPageRoute(builder: (context)=> const AddAnnouncementScreen()),
          );
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        // Bottom navigator
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
                  label: 'Profil'),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Colors.indigo,
              unselectedItemColor: Colors.grey[600],
            ) 
          ),
    );
  }
}