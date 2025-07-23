import 'package:flutter/material.dart';

class LogMoodPage extends StatelessWidget {
  const LogMoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Tracker"),
        backgroundColor: const Color.fromRGBO(192, 204, 218, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: const Center(
        child: Text(
          "TO BE DONE",
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
