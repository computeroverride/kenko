import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(192, 204, 218, 1),
        centerTitle: true,
        title: Text("PROFILE",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: const Color.fromRGBO(66, 76, 90, 1),
        )),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          // Avatar + Name
          const CircleAvatar(
            radius: 45,
            backgroundColor: Colors.black12,
            child: Icon(Icons.account_circle, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            "BOO ash",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 40),

          // Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.circle, color: Colors.blueGrey),
                  title: const Text(
                    "Update Email",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    // TODO: Navigate to update email screen
                  },
                ),
                const Divider(thickness: 1),

                ListTile(
                  leading: Icon(Icons.circle, color: Colors.blueGrey),
                  title: const Text(
                    "Update Personal Details",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    // TODO: Navigate to update personal details screen
                  },
                ),
                const Divider(thickness: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}