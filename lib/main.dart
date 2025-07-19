import 'package:flutter/material.dart';
import 'package:kenko/home.dart';
import 'package:kenko/login.dart';
import 'package:kenko/profile.dart';
import 'signup.dart';

void main() {
  runApp(
    MaterialApp(
      home: (Login()),
      routes: {
        '/signup': (context) => Signup(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/profile': (context) => Profile(),
      },
    ),
  );
}
