import 'package:flutter/material.dart';

class MentalPage extends StatefulWidget {
  const MentalPage({super.key});

  @override
  State<MentalPage> createState() => _MentalPageState();
}

class _MentalPageState extends State<MentalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mental Well-being")),
      body: Center(child: Text("Welcome to the Mental Health page")),
    );
  }
}
