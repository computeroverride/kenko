import 'package:flutter/material.dart';

class LogAdd extends StatelessWidget {
  const LogAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Make container full width
      padding: const EdgeInsets.all(16), // Uniform padding for spacing

      child: Column(
        mainAxisSize: MainAxisSize.min, // Height adjusts based on content
        crossAxisAlignment: CrossAxisAlignment.stretch, // Children stretch horizontally

        children: [
          // --- Food and Water Log Option ---
          ListTile(
            leading: const Icon(Icons.rice_bowl, color: Colors.blueGrey),
            title: const Text(
              "Food and Water Log",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close the bottom sheet
              Navigator.pushReplacementNamed(context, '/food&water'); // Navigate to food & water log page
            },
          ),
          const Divider(thickness: 1),

          // --- Activity Log Option ---
          ListTile(
            leading: const Icon(Icons.local_activity, color: Colors.blueGrey),
            title: const Text(
              "Activity Log",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close the bottom sheet
              Navigator.pushReplacementNamed(context, '/activity'); // Navigate to activity log page
            },
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
