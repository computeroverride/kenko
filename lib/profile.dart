import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Updemail.dart';
import 'upddetails.dart'; // Import the new UpdateDetails page

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _username = "User"; // Default username

  @override
  void initState() {
    super.initState();
    _fetchUsername(); // Fetch username from Firestore
  }

  Future<void> _fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && doc.data() != null) {
        setState(() {
          _username = doc.get('username') ?? "User";
        });
      }
    }
  }

  // Function to handle logout
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Page background color set to white
      // --- Top App Bar ---
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(192, 204, 218, 1), // Light blue-grey header
        centerTitle: true, // Centers the title text
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(66, 76, 90, 1)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home'); // Navigate to Home page
          },
        ),
        title: Text(
          "PROFILE", // Title displayed in app bar
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: const Color.fromRGBO(66, 76, 90, 1), // Dark greyish text color
          ),
        ),
      ),

      // --- Main Body Content ---
      body: Column(
        children: [
          const SizedBox(height: 30), // Top spacing
          // --- Profile Avatar and Name ---
          const CircleAvatar(
            radius: 45, // Size of circular avatar
            backgroundColor: Colors.black, // Background of avatar circle
            child: Icon(
              Icons.account_circle, // Profile icon inside avatar
              size: 50,
              color: Colors.white, // Icon color
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Hello, $_username!", // Updated to display username
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 40),

          // --- Settings / Options List ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0), // Horizontal padding
            child: Column(
              children: [
                // Update Email Option
                ListTile(
                  leading: Icon(
                    Icons.circle,
                    color: Colors.blueGrey,
                  ), // Icon before text
                  title: const Text(
                    "Update Email",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdateEmail()),
                    );
                  },
                ),
                const Divider(thickness: 1), // Divider line
                // Update Personal Details Option
                ListTile(
                  leading: Icon(
                    Icons.circle,
                    color: Colors.blueGrey,
                  ), // Icon before text
                  title: const Text(
                    "Update Personal Details",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UpdateDetails()),
                    );
                  },
                ),
                const Divider(thickness: 1), // Divider line
                // Logout Option
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.blueGrey,
                  ), // Logout icon
                  title: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () => _logout(context), // Call logout function
                ),
                const Divider(thickness: 1), // Divider line
              ],
            ),
          ),
        ],
      ),
    );
  }
}