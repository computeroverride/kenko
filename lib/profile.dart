import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
          const Text(
            "Welcome!", // Displayed user name
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 40),

          // --- Settings / Options List ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0), // Horizontal padding
            child: Column(
              children: [
                // Update Email Option
                ListTile(
                  leading: Icon(Icons.circle, color: Colors.blueGrey), // Icon before text
                  title: const Text(
                    "Update Email",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    // TODO: Navigate to update email screen
                  },
                ),
                const Divider(thickness: 1), // Divider line

                // Update Personal Details Option
                ListTile(
                  leading: Icon(Icons.circle, color: Colors.blueGrey), // Icon before text
                  title: const Text(
                    "Update Personal Details",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    // TODO: Navigate to update personal details screen
                  },
                ),
                const Divider(thickness: 1), // Divider line

                // Logout Option
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.blueGrey), // Logout icon
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