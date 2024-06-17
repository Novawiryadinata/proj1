import 'package:flutter/material.dart';
import 'package:proj1/kamera_scan_screen.dart';
import 'package:proj1/profil_screen.dart';
import 'package:proj1/absensi_screen.dart';
import 'bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'package:proj1/kelasA.dart';
import 'package:proj1/kelasB.dart';
import 'package:proj1/kelasC.dart';
import 'package:proj1/kelasD.dart';

class CrudStudents extends StatefulWidget {
  @override
  _CrudStudentsState createState() => _CrudStudentsState();
}

class _CrudStudentsState extends State<CrudStudents> {
  String? studentKelas;
  String? studentNama;
  String? studentNim;
  String? selectedKelas;
  TextEditingController kelasController = TextEditingController();
  String defaultKelas = 'A';

  TextEditingController namaController = TextEditingController();
  TextEditingController nimController = TextEditingController();

  bool isGridViewVisible = true;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    // Ensure selectedKelas is initialized
    selectedKelas = defaultKelas;
    kelasController.text = defaultKelas;
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(); // Initialize Firebase
  }

  void getstudentNama(String name) {
    this.studentNama = name;
  }

  void getStudentNim(String nim) {
    this.studentNim = nim;
  }

  void createData() {
    print("Created");

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudents").doc(studentNim);

    Map<String, dynamic> students = {
      "studentNama": studentNama,
      "studentNim": studentNim,
      "studentKelas": studentKelas,
    };

    documentReference.set(students).then((_) {
      print("-->>>> $studentNim, $studentNama, $studentKelas created");
    }).catchError((error) {
      print(
          "-->>>> Failed to create $studentNim, $studentNama, $studentKelas: $error");
    });

    setState(() {
      selectedKelas = defaultKelas;
      kelasController.text = defaultKelas;
    });

    namaController.clear();
    nimController.clear();
  }

  void resetKelas() {
    setState(() {
      selectedKelas = defaultKelas;
      kelasController.text = defaultKelas; // Reset kelasController value
    });
  }

  void toggleGridViewVisibility() {
    setState(() {
      isGridViewVisible = !isGridViewVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Data Siswa'),
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: toggleGridViewVisibility,
              child: Text(
                  isGridViewVisible ? "Hide Kelas Card" : "Show Kelas Card"),
            ),
            Visibility(
              visible: isGridViewVisible,
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16.0),
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: "Name",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                onChanged: (String name) {
                  getstudentNama(name);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TextFormField(
                controller: nimController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: "NIM",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                onChanged: (String nim) {
                  getStudentNim(nim);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Kelas",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                value: selectedKelas ?? defaultKelas,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedKelas = newValue!;
                    studentKelas = newValue;
                    kelasController.text = newValue;
                  });
                },
                items: <String>['A', 'B', 'C', 'D']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    createData();
                    resetKelas();
                  },
                  child: Text("Create"),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('MyStudents')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return Text('No data available');
                }

                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final studentData =
                        documents[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(studentData['studentNama']),
                      subtitle: Text(
                          'NIM: ${studentData['studentNim']} - Kelas: ${studentData['studentKelas']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.yellow),
                            onPressed: () {
                              editMyStudent(studentData['studentNim']);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Konfirmasi Hapus"),
                                  content: Text(
                                      "Apakah Anda yakin ingin menghapus item ini?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('MyStudents')
                                              .doc(studentData['studentNim'])
                                              .delete();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text("Item berhasil dihapus"),
                                            ),
                                          );
                                          Navigator.of(context).pop();
                                        } catch (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Gagal menghapus item: $error"),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                      child: Text("Hapus"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AbsensiScreen()),
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

  Future<void> editMyStudent(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('MyStudents').doc(id).get();

    String studentName = doc['studentNama'];
    String studentNim = doc['studentNim'];
    String studentKelas = doc['studentKelas'];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Student Data"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: studentName, // Display current name
                  decoration: InputDecoration(
                    labelText: "Name",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  onChanged: (String name) {
                    studentName = name;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: studentNim, // Display current NIM
                  decoration: InputDecoration(
                    labelText: "NIM",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  onChanged: (String nim) {
                    studentNim = nim;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: studentKelas, // Display current class
                  decoration: InputDecoration(
                    labelText: "Kelas",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      studentKelas = newValue!;
                    });
                  },
                  items: <String>['A', 'B', 'C', 'D'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('MyStudents')
                  .doc(id)
                  .delete();

              await FirebaseFirestore.instance
                  .collection('MyStudents')
                  .doc(studentNim)
                  .set({
                'studentNama': studentName,
                'studentNim': studentNim,
                'studentKelas': studentKelas,
              });

              Navigator.of(context).pop(); // Close dialog after saving
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
