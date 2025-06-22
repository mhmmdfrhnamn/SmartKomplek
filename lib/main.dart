import 'package:smart_komplek/presentation/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // inisiasi firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // mengatur font ke seluruh aplikasi
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),

      // navigasi ke halaman login
      home: const LoginScreen(),
    );
  }
}