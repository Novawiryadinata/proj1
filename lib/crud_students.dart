import 'package:flutter/material.dart';
import 'package:proj1/kamera_scan_screen.dart';
import 'package:proj1/profil_screen.dart';
import 'bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

class CrudStudents extends StatefulWidget {
  @override
  _CrudStudentsState createState() => _CrudStudentsState();
}

class _CrudStudentsState extends State<CrudStudents> {
  String? studentKelas;
  // String selectedValue = 'A';
  String? studentNama;
  String? studentNim;
  String selectedKelas = 'A'; // Nilai default untuk DropdownButtonFormField
  String defaultKelas = 'A'; // Nilai default yang disimpan

  TextEditingController kelasController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController nimController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(); // Inisialisasi Firebase
  }

  void getstudentNama(name) {
    this.studentNama = name;
  }

  void getStudentNim(String nim) {
    this.studentNim = nim;
  }

  createData() {
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

    // kelasController.clear();
    namaController.clear();
    nimController.clear();
  }

  void resetKelas() {
    setState(() {
      selectedKelas = defaultKelas;
      kelasController.text =
          defaultKelas; // Mengatur kembali nilai dalam kelasController
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Data Siswa'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              controller: namaController,
              decoration: InputDecoration(
                  labelText: "Name",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0))),
              onChanged: (String name) {
                getstudentNama(name);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: TextFormField(
              controller: nimController,
              keyboardType:
                  TextInputType.number, // Mengatur keyboard untuk tipe angka
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter
                    .digitsOnly // Memastikan input hanya menerima angka
              ],
              decoration: InputDecoration(
                  labelText: "NIM",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0))),
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
              // controller: kelasController,
              value:
                  selectedKelas, // Nilai default untuk DropdownButtonFormField
              onChanged: (String? newValue) {
                setState(() {
                  selectedKelas = newValue!;
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
                  // primary: Colors.blue, // Warna latar belakang tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        18), // Bentuk tombol dengan sudut melengkung
                  ),
                ),
                onPressed: () {
                  // Aksi yang akan dilakukan ketika tombol ditekan
                  createData();
                  resetKelas();
                  // print('Tombol ditekan!');
                },
                child: Text("Create"), // Isi dari tombol
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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
                // Data berhasil diambil, sekarang kita akan membangun UI
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
                      // Tambahkan tindakan lain jika diperlukan
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.yellow),
                            onPressed: () {
                              editMyStudent(studentData['studentNim']);
                              // Tambahkan fungsi untuk mengedit item di sini
                              // Misalnya, menavigasi ke halaman edit dengan parameter data mahasiswa
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Tampilkan dialog konfirmasi sebelum menghapus item
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Konfirmasi Hapus"),
                                  content: Text(
                                      "Apakah Anda yakin ingin menghapus item ini?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Tutup dialog konfirmasi
                                      },
                                      child: Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Menghapus item dari Firebase Firestore
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('MyStudents')
                                              .doc(studentNim)
                                              .delete();
                                          // Menampilkan pesan sukses jika item berhasil dihapus
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text("Item berhasil dihapus"),
                                            ),
                                          );
                                          Navigator.of(context)
                                              .pop(); // Tutup dialog konfirmasi
                                        } catch (error) {
                                          // Menampilkan pesan kesalahan jika terjadi masalah saat menghapus item
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
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KameraScanScreen()),
            );
          } else if (index == 2) {
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
    // Mengambil data mahasiswa dari Firestore berdasarkan ID
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('MyStudents').doc(id).get();

    // Mendapatkan data mahasiswa
    String studentName = doc['studentNama'];
    String studentNim = doc['studentNim'];
    String studentKelas = doc['studentKelas'];

    // Menampilkan dialog AlertDialog untuk mengedit data mahasiswa
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
                  initialValue: studentName, // Menampilkan nama saat ini
                  decoration: InputDecoration(
                    labelText: "Name",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  onChanged: (String name) {
                    // Mendapatkan nama yang diubah jika diperlukan
                    studentName = name;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: studentNim, // Menampilkan NIM saat ini
                  decoration: InputDecoration(
                    labelText: "NIM",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  onChanged: (String nim) {
                    // Mendapatkan NIM yang diubah jika diperlukan
                    studentNim = nim;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: studentKelas, // Menampilkan kelas saat ini
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
              Navigator.of(context).pop(); // Tutup dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // Hapus dokumen lama dengan id lama
              await FirebaseFirestore.instance
                  .collection('MyStudents')
                  .doc(id)
                  .delete();

              // Tambahkan dokumen baru dengan id baru (studentNim yang baru)
              await FirebaseFirestore.instance
                  .collection('MyStudents')
                  .doc(studentNim)
                  .set({
                'studentNama': studentName,
                'studentNim': studentNim,
                'studentKelas': studentKelas,
              });

              Navigator.of(context).pop(); // Tutup dialog setelah menyimpan
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
