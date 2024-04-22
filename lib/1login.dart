// import 'package:flutter/material.dart';

// void main() {
//   runApp(AbsenApp());
// }

// class AbsenApp extends StatelessWidget {
//   const AbsenApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(20), // Tambahkan padding di sekitar body.
//           child: SingleChildScrollView(
//             // Menggunakan SingleChildScrollView
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Image.asset(
//                     'asset/image/logo.png', // Pastikan path ke gambar benar.
//                   ),
//                   SizedBox(height: 20),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text(
//                         'Username',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Masukkan Username',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Color.fromARGB(255, 41, 84, 58)),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Color.fromARGB(255, 41, 84, 58)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text(
//                         'Password',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Masukkan Password',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Color.fromARGB(255, 41, 84, 58)),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Color.fromARGB(255, 41, 84, 58)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Fungsi untuk tombol Login
//                     },
//                     child: Text(
//                       'LOGIN',
//                       style: TextStyle(
//                           color: Colors
//                               .white), // Mengatur warna teks menjadi putih
//                     ),
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all<Color>(
//                           Color.fromARGB(255, 41, 84, 58)),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Fungsi untuk tombol Daftar
//                     },
//                     child: Text(
//                       'DAFTAR',
//                       style: TextStyle(
//                           color: Colors
//                               .white), // Mengatur warna teks menjadi putih
//                     ),
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all<Color>(
//                           Colors.grey), // Mengubah warna untuk tombol ini
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }