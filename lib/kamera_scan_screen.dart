import 'package:flutter/material.dart';
// import 'bottom_navigation_bar.dart';
import 'package:proj1/bottom_navigation_bar.dart';
import 'package:proj1/profil_screen.dart';
import 'package:proj1/crud_students.dart';
import 'package:proj1/absensi_screen.dart';

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
    return AlertDialog(
      title: Text('Scan Result'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',
            ),
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

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
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
