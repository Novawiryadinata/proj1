// import 'package:proj1/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj1/bottom_navigation_bar.dart';
import 'package:proj1/kamera_scan_screen.dart';
import 'package:proj1/crud_students.dart';
import 'package:proj1/absensi_screen.dart';

import 'package:proj1/login.dart';
import 'package:proj1/edit_akun.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User?> getUser() async {
  return FirebaseAuth.instance.authStateChanges().first;
}

class ProfilScreen extends StatelessWidget {
  // FirebaseUser user = await FirebaseAuth.instance.currentUser();
  // String userEmail = user.email;

  // final List<String> emails = [userEmail];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 41, 84, 58),
        title: const Text(
          "Profile Akun",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            // Mengatur warna teks menjadi putih
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigasi ke halaman utama atau login
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      AbsensiScreen()), // Ganti dengan halaman utama jika diperlukan
              (Route<dynamic> route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => editakun()),
              );

              // Fungsi yang akan dijalankan ketika tombol pengaturan ditekan
              // Tambahkan logika di sini untuk menangani ketika tombol ditekan
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 140, // Lebar dan tinggi kontainer foto profil
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                          'asset/image/lisab.jpg'), // Pastikan path ke gambar benar.
                    ),
                  ),
                ),
              ),

              SizedBox(height: 5),
              Divider(
                color: Colors.grey, // Mengatur warna garis menjadi abu-abu
                thickness: 1, // Mengatur ketebalan garis
              ),
              FutureBuilder<User?>(
                future: getUser(),
                builder: (context, AsyncSnapshot<User?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  String? userEmail = snapshot.data?.email;
                  return Text(
                    userEmail ?? 'No Email',
                    style: TextStyle(fontSize: 24),
                  );
                },
              ),

              // SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     // Tambahkan logika untuk mengedit profil
              //   },
              //   child: Text('Edit Profil'),
              // ),

              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    'LOGOUT',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 41, 84, 58),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AbsensiScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CrudStudents()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KameraScanScreen()),
            );
          }
        },
      ),
    );
  }
}
