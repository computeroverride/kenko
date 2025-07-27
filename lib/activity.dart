import 'package:flutter/material.dart';
import 'package:kenko/logadd.dart';

class ActivityLog extends StatefulWidget {
  const ActivityLog({super.key});

  @override
  State<ActivityLog> createState() => _ActivityLogState();
}

class _ActivityLogState extends State<ActivityLog> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Tracks which nav item is selected
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // --- App Bar ---
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(192, 204, 218, 1),
        centerTitle: true,
        title: const Text(
          "ADD TO ACTIVITY LOG",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.black,
          ),
        ),
      ),

      // --- Body Content ---
      body: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                // --- Workout Button ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey, // updated color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/workout');
                    },
                    child: const Text(
                      "WORKOUT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Steps Button ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/step');
                    },
                    child: const Text(
                      "STEPS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueGrey, // updated color
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 2) {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              builder: (context) => const LogAdd(),
            );
          } else if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/map');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/mental');
          } else {
            _onItemTapped(index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Mental'),
        ],
      ),
    );
  }
}
