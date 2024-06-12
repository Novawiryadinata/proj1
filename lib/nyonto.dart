import 'package:flutter/material.dart';
import 'package:proj1/bottom_navigation_bar.dart';
import 'package:proj1/profil_screen.dart';
import 'package:proj1/crud_students.dart';
import 'package:proj1/absensi_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'dart:io';
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
  String? studentNama;
  String? studentKelas;
  String? studentNim;

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
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => AbsensiScreen()),
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
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () async {
              await controller?.flipCamera();
              setState(() {});
            },
            child: Icon(Icons.flip_camera_android),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () async {
              await controller?.pauseCamera();
            },
            child: Icon(Icons.pause),
          ),
          SizedBox(width: 16),
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
          child: Text('OK'),
        ),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 500 ||
            MediaQuery.of(context).size.height < 500)
        ? 250.0
        : 500.0;
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

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      if (result != null) {
        await _fetchStudentData(result!.code);
      }
    });
  }

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
          studentKelas = '';
          this.studentNim = '';
        });
      }
    } catch (e) {
      setState(() {
        studentNama = 'Error: $e';
        studentKelas = '';
        this.studentNim = '';
      });
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
