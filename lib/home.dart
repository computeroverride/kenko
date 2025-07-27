import 'package:flutter/material.dart';
import 'package:kenko/logadd.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0; // Tracks currently selected bottom navigation index

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Updates selected index
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
          "HOME",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.blueGrey, // <-- changed
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.blueGrey), 
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile'); // Go to profile page
            },
          ),
        ],
      ),

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          if (index == 2) {
            // Show add log modal sheet
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              builder: (context) => const LogAdd(),
            );
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/map'); // Navigate to map
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/mental'); // Navigate to mental
          } else {
            _onItemTapped(index); // Switch to home or dashboard tab
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
