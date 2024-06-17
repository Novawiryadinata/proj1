import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proj1/absensi_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RekapanBApp(),
    );
  }
}

class RekapanBApp extends StatefulWidget {
  @override
  _RekapanBAppState createState() => _RekapanBAppState();
}

class _RekapanBAppState extends State<RekapanBApp> {
  bool _initialized = false;
  bool _error = false;

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
      return Scaffold(
        body: Center(
          child: Text('Failed to initialize Firebase'),
        ),
      );
    }

    if (!_initialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance List for Kelas B'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => AbsensiScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: StudentListScreen(),
    );
  }
}

class StudentListScreen extends StatelessWidget {
  final String kelasFilter = 'B'; // The class to filter by

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

        // Initialize the map to hold grouped data
        Map<String, List<Map<String, dynamic>>> groupedByDate = {};

        // Group data by date
        documents.forEach((document) {
          var documentData = document.data() as Map<String, dynamic>;
          var attendanceList = documentData['attendance'] as List<dynamic>;

          attendanceList.forEach((attendance) {
            if (attendance['studentKelas'] == kelasFilter) {
              String dateKey = document.id;
              if (!groupedByDate.containsKey(dateKey)) {
                groupedByDate[dateKey] = [];
              }
              groupedByDate[dateKey]!.add(attendance);
            }
          });
        });

        if (groupedByDate.isEmpty) {
          return Center(
            child: Text('No attendance for Kelas B'),
          );
        }

        // Build the list view
        return ListView(
          children: groupedByDate.entries.map((entry) {
            String date = entry.key;
            List<Map<String, dynamic>> attendances = entry.value;
            int totalAttendance = attendances.length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title:
                      Text('Tanggal: $date - Jumlah Siswa: $totalAttendance'),
                ),
                Column(
                  children: attendances.map((attendance) {
                    return ListTile(
                      title: Text(attendance['studentNama']),
                      subtitle: Text(
                        'NIM: ${attendance['studentNim']} - Kelas: ${attendance['studentKelas']} - Time: ${attendance['dateTime']}',
                      ),
                    );
                  }).toList(),
                ),
                Divider(),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
