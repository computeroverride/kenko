import 'package:flutter/material.dart';
import 'package:kenko/activity.dart';
import 'package:kenko/foodwater.dart';
import 'package:kenko/home.dart';
import 'package:kenko/login.dart';
import 'package:kenko/mappage.dart';
import 'package:kenko/profile.dart';
import 'package:kenko/signup.dart';
import 'package:kenko/mental.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (Login()),
      routes: {
        '/signup': (context) => Signup(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/profile': (context) => Profile(),
        '/food&water': (context) => FoodWaterLog(),
        '/activity': (context) => ActivityLog(),
        '/map': (context) => FreeMapScreen(),
        '/mental': (context) => MentalPage(),

      },
    ),
  );
}
