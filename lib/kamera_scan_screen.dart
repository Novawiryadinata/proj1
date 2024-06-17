import 'package:flutter/material.dart';
// import 'bottom_navigation_bar.dart';
import 'package:proj1/bottom_navigation_bar.dart';
import 'package:proj1/profil_screen.dart';
import 'package:proj1/crud_students.dart';
import 'package:proj1/absensi_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:developer';
import 'dart:io';

import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class KameraScanScreen extends StatefulWidget {
  const KameraScanScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<KameraScanScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // tambahan
  String? studentNama;
  String? studentKelas;
  String? studentNim;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Camera QR Code'),
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
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                _buildQrView(context),
                if (result != null) _buildScanResultDialog(context),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {});
            },
            child: Icon(Icons.flash_on),
          ),
          SizedBox(width: 16), // Beri jarak antara ikon mengambang
          FloatingActionButton(
            onPressed: () async {
              await controller?.flipCamera();
              setState(() {});
            },
            child: Icon(Icons.flip_camera_android),
          ),
          SizedBox(width: 16), // Beri jarak antara ikon mengambang
          FloatingActionButton(
            onPressed: () async {
              await controller?.pauseCamera();
            },
            child: Icon(Icons.pause),
          ),
          SizedBox(width: 16), // Beri jarak antara ikon mengambang
          FloatingActionButton(
            onPressed: () async {
              await controller?.resumeCamera();
            },
            child: Icon(Icons.play_arrow),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 2,
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

  Widget _buildScanResultDialog(BuildContext context) {
    if (studentNama == null || studentKelas == null || studentNim == null) {
      return Center(child: CircularProgressIndicator());
    }

    return AlertDialog(
      title: Text('Scan Result'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Nama: $studentNama'),
            Text('Kelas: $studentKelas'),
            Text('NIM: $studentNim'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        if (studentNama !=
            'Data tidak ditemukan') // Tampilkan tombol "Hadir" hanya jika data ditemukan
          TextButton(
            onPressed: () async {
              await _markAttendance();
            },
            child: Text('Hadir'),
          ),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 500 ||
            MediaQuery.of(context).size.height < 500)
        ? 250.0
        : 500.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

// // lama
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      String? studentNim = scanData.code;
      // Ensure the studentNim is not null and does not contain '//' before fetching data
      if (studentNim != null && !studentNim.contains("//")) {
        await _fetchStudentData(studentNim);
      } else {
        setState(() {
          studentNama = 'Data tidak ditemukan';
          studentKelas = 'Data tidak ditemukan';
          this.studentNim = 'Data tidak ditemukan';
        });
      }
    });
  }

// tambahan
  Future<void> _fetchStudentData(String studentNim) async {
    try {
      var document = await FirebaseFirestore.instance
          .collection('MyStudents')
          .doc(studentNim)
          .get();

      if (document.exists) {
        setState(() {
          studentNama = document['studentNama'];
          studentKelas = document['studentKelas'];
          this.studentNim = document['studentNim'];
        });
      } else {
        setState(() {
          studentNama = 'Data tidak ditemukan';
          studentKelas = 'Data tidak ditemukan';
          this.studentNim = 'Data tidak ditemukan';
        });
      }
    } catch (e) {
      setState(() {
        studentNama = 'Error: $e';
        studentKelas = 'Error: $e';
        this.studentNim = 'Error: $e';
      });
    }
  }

// baru
  Future<void> _markAttendance() async {
    try {
      DateTime now = DateTime.now();
      String docId = DateFormat('yyyy-MM-dd').format(now);
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('Rekapan').doc(docId);

      await docRef.get().then((docSnapshot) async {
        if (docSnapshot.exists) {
          var attendanceList = docSnapshot['attendance'] as List<dynamic>;
          bool alreadyMarked = attendanceList
              .any((attendance) => attendance['studentNim'] == studentNim);

          if (alreadyMarked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Siswa sudah hadir hari ini')),
            );
          } else {
            await docRef.update({
              'attendance': FieldValue.arrayUnion([
                {
                  'studentNama': studentNama,
                  'studentNim': studentNim,
                  'studentKelas': studentKelas,
                  'dateTime': now.toIso8601String(),
                }
              ]),
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Kehadiran berhasil ditandai')),
            );
          }
        } else {
          await docRef.set({
            'attendance': [
              {
                'studentNama': studentNama,
                'studentNim': studentNim,
                'studentKelas': studentKelas,
                'dateTime': now.toIso8601String(),
              }
            ],
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kehadiran berhasil ditandai')),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
