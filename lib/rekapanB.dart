import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proj1/absensi_screen.dart';

class RekapanBApp extends StatefulWidget {
  @override
  _RekapanBAppState createState() => _RekapanBAppState();
}

class _RekapanBAppState extends State<RekapanBApp> {
  bool _initialized = false;
  bool _error = false;

  // final String kelasFilter = 'B'; // The class to filter by

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  // Initialize Firebase
  void initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Failed to initialize Firebase'),
          ),
        ),
      );
    }

    if (!_initialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Student List Kelas B',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentListScreenB(),
    );
  }
}

class StudentListScreenB extends StatelessWidget {
  final String kelasFilter = 'B'; // The class to filter by

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance List for Kelas $kelasFilter'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to the main or login page
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      AbsensiScreen()), // Change to the main page if needed
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Rekapan').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No attendance data found'));
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          // Initialize the list to hold grouped data
          List<Map<String, dynamic>> groupedData = [];

          // Group data by document ID
          for (var document in documents) {
            var documentData = document.data() as Map<String, dynamic>;
            groupedData.add({'id': document.id, 'data': documentData});
          }

          // Filter data based on kelas
          List<Map<String, dynamic>> filteredData = [];
          for (var group in groupedData) {
            var attendanceList = group['data']['attendance'] as List<dynamic>;
            for (var attendance in attendanceList) {
              if (attendance['studentKelas'] == kelasFilter) {
                filteredData.add({
                  'id': group['id'],
                  'attendance': attendance,
                });
              }
            }
          }

          if (filteredData.isEmpty) {
            return Center(
              child: Text('Kehadiran Kelas $kelasFilter'),
            );
          }

          return ListView.builder(
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              final attendanceData = filteredData[index];
              return Column(
                children: [
                  ListTile(
                    title: Text('Tanggal: ${attendanceData['id']}'),
                  ),
                  ListTile(
                    title: Text(attendanceData['attendance']['studentNama']),
                    subtitle: Text(
                      'NIM: ${attendanceData['attendance']['studentNim']} - Kelas: ${attendanceData['attendance']['studentKelas']} - Date: ${attendanceData['id']} - Time: ${attendanceData['attendance']['dateTime']}',
                    ),
                  ),
                  Divider(), // Add a divider after each group
                ],
              );
            },
          );
        },
      ),
    );
  }
}
