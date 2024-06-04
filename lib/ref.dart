import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart';

class KameraScanScreen extends StatefulWidget {
  const KameraScanScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<KameraScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedNim;
  Map<String, dynamic>? studentData;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null && scannedNim != scanData.code) {
        scannedNim = scanData.code;
        await fetchStudentData(scannedNim!);
        if (studentData != null) {
          await savePresensiData();
        }
      }
    });
  }

  Future<void> fetchStudentData(String nim) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('MyStudents')
          .doc(nim)
          .get();
      if (snapshot.exists) {
        setState(() {
          studentData = snapshot.data() as Map<String, dynamic>?;
        });
      } else {
        setState(() {
          studentData = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student not found!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<void> savePresensiData() async {
    try {
      String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

      DocumentReference docRef = FirebaseFirestore.instance
          .collection('PresensiStudents')
          .doc(formattedDate);

      Map<String, dynamic> presensiEntry = {
        'studentNama': studentData!['studentNama'],
        'studentNim': studentData!['studentNim'],
        'studentKelas': studentData!['studentKelas'],
        'timestamp': currentTime,
      };

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        if (snapshot.exists) {
          List<dynamic> existingData = snapshot.get('entries') as List<dynamic>;
          existingData.add(presensiEntry);
          transaction.update(docRef, {'entries': existingData});
        } else {
          transaction.set(docRef, {
            'entries': [presensiEntry]
          });
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance recorded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving attendance: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (scannedNim != null)
                  ? Text('NIM: $scannedNim')
                  : Text('Scan a code'),
            ),
          ),
        ],
      ),
    );
  }
}
