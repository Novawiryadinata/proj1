// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:proj1/signup.dart';
// import 'package:proj1/absensi_screen.dart';

// // void main() {
// //   runApp(Login());
// // }

// class Login extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: login(),
//     );
//   }
// }

// class login extends StatefulWidget {
//   @override
//   _loginState createState() => _loginState();
// }

// class _loginState extends State<login> {
//   TextEditingController _emailTextController = TextEditingController();
//   TextEditingController _passwordTextController = TextEditingController();

//   void checkUserLoggedIn() {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     if (auth.currentUser != null) {
//       // User is already logged in, navigate to AbsensiScreen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => AbsensiScreen(),
//         ),
//       );
//     }
//   }

//   void _showErrorDialog(String errorMessage) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Gagal Login'),
//           content: Text(errorMessage),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Image.asset(
//                   'asset/image/science.png',
//                   width: 30, // Lebar yang diinginkan
//                   fit: BoxFit.contain,
//                 ),
//                 SizedBox(height: 20),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text(
//                       'Username',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     TextFormField(
//                       controller: _emailTextController,
//                       decoration: InputDecoration(
//                         hintText: 'Masukkan Username',
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                               color: Color.fromARGB(255, 41, 84, 58)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                               color: Color.fromARGB(255, 41, 84, 58)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text(
//                       'Password',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     TextFormField(
//                       controller: _passwordTextController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         hintText: 'Masukkan Password',
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                               color: Color.fromARGB(255, 41, 84, 58)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                               color: Color.fromARGB(255, 41, 84, 58)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     FirebaseAuth.instance
//                         .signInWithEmailAndPassword(
//                       email: _emailTextController.text,
//                       password: _passwordTextController.text,
//                     )
//                         .then((value) {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AbsensiScreen(),
//                         ),
//                       );
//                     }).catchError((error) {
//                       // Show error dialog when login fails
//                       _showErrorDialog('Gagal login: $error');
//                     });
//                   },
//                   child: Text(
//                     'LOGIN',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all<Color>(
//                       Color.fromARGB(255, 41, 84, 58),
//                     ),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SignUpScreen()),
//                     );
//                   },
//                   child: Text(
//                     'DAFTAR',
//                     style: TextStyle(
//                       color: Color.fromARGB(255, 41, 84, 58),
//                     ),
//                   ),
//                   style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.all<Color>(Colors.white),
//                     side: MaterialStateProperty.all(BorderSide(
//                       color: Color.fromARGB(255, 41, 84, 58),
//                       width: 2.0,
//                     )),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'absensi_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proj1/signup.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Menyimpan status login ke SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AbsensiScreen()),
      );
    } catch (e) {
      print('Failed to sign in with Email & Password');
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'asset/image/science.png',
              width: 100, // Lebar yang diinginkan
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Username',
                  style: TextStyle(fontSize: 16),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Username',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 41, 84, 58)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 41, 84, 58)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Password',
                  style: TextStyle(fontSize: 16),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Password',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 41, 84, 58)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 41, 84, 58)),
                    ),
                  ),
                ),
              ],
            ),

            // TextField(
            //   controller: _emailController,
            //   decoration: InputDecoration(labelText: 'Email'),
            // ),
            // TextField(
            //   controller: _passwordController,
            //   decoration: InputDecoration(labelText: 'Password'),
            //   obscureText: true,
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text(
                'LOGIN',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 41, 84, 58),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text(
                'DAFTAR',
                style: TextStyle(
                  color: Color.fromARGB(255, 41, 84, 58),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                side: MaterialStateProperty.all(BorderSide(
                  color: Color.fromARGB(255, 41, 84, 58),
                  width: 2.0,
                )),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
