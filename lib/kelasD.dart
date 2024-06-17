import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proj1/absensi_screen.dart';
import 'package:proj1/crud_students.dart';

class KelasDApp extends StatefulWidget {
  @override
  _KelasDAppState createState() => _KelasDAppState();
}

class _KelasDAppState extends State<KelasDApp> {
  bool _initialized = false;
  bool _error = false;

  final String kelasFilter = 'A'; // The class to filter by

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
      title: 'Student List Kelas A',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentListScreen(),
    );
  }
}

class StudentListScreen extends StatelessWidget {
  final String kelasFilter = 'D'; // The class to filter by

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List for Kelas $kelasFilter'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to the main or login page
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      CrudStudents()), // Change to the main page if needed
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('MyStudents')
            .where('studentKelas', isEqualTo: kelasFilter)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('No students found for Kelas $kelasFilter'));
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final studentData =
                  documents[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(studentData['studentNama']),
                subtitle: Text(
                    'NIM: ${studentData['studentNim']} - Kelas: ${studentData['studentKelas']}'),
              );
            },
          );
        },
      ),
    );
  }
}
