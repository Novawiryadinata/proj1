import 'package:flutter/material.dart';
import 'package:proj1/kamera_scan_screen.dart';
import 'package:proj1/profil_screen.dart';
import 'package:proj1/crud_students.dart';
import 'package:proj1/kelasA.dart';
import 'package:proj1/kelasB.dart';
import 'package:proj1/kelasC.dart';
import 'package:proj1/kelasD.dart';
import 'bottom_navigation_bar.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// // ...

// await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );

class AbsensiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Absensi'),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16.0),
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            ClassCard(
              className: 'A',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => KelasAApp(),
                ));
              },
            ),
            ClassCard(
              className: 'B',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => KelasBApp(),
                ));
              },
            ),
            ClassCard(
              className: 'C',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => KelasCApp(),
                ));
              },
            ),
            ClassCard(
              className: 'D',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => KelasDApp(),
                ));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CrudStudents()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KameraScanScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilScreen()),
            );
          }
        },
      ),
    );
  }
}

class ClassCard extends StatelessWidget {
  final String className;
  final VoidCallback onTap;

  ClassCard({required this.className, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueAccent,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            'Kelas $className',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
