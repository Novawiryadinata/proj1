import 'package:flutter/material.dart';
import 'package:proj1/absensi_screen.dart';
// import 'package:firebase_core/firebase_core.dart';s

// import 'absensi_screen.dart';
// import 'kamera_scan_screen.dart';
// import 'profil_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ngabsenin',
      debugShowCheckedModeBanner:
          false, // Tambahkan debugShowCheckedModeBanner: false
      theme: ThemeData(
          // Tambahkan konfigurasi theme
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          secondaryHeaderColor: Colors.cyan),
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      home: AbsensiScreen(), // Mulai dengan AbsensiScreen
    );
  }
}
