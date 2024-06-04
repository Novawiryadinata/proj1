import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import '/signup.dart';
// import '/login.dart';

import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  final String _apiKey = "AIzaSyDbV9XUZxZT5rCjpvmDMft27PoJMCArDys";

  Future<void> SignUpScreen(String email, String password) async {
    final url = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDbV9XUZxZT5rCjpvmDMft27PoJMCArDys",
    );

    try {
      final response = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseData);
      } else {
        throw Exception(responseData['error']['message']);
      }
    } catch (error) {
      print(error);
    }
  }
}

Future<void> login(String email, String password) async {
  final url = Uri.parse(
    "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDbV9XUZxZT5rCjpvmDMft27PoJMCArDys",
  );

  try {
    final response = await http.post(
      url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      print(responseData);
      print("oyoy");
    } else {
      throw Exception(responseData['error']['message']);
    }
  } catch (error) {
    print(error);
  }
}
