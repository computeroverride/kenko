import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kenko/logadd.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/health.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0; // Tracks currently selected bottom navigation index
  String _username = "User"; // Added to store username

  // Step tracking variables
  final Health _health = Health();
  int _totalSteps = 0;
  double _totalDistance = 0.0; // meters
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _fetchUsername(); // Fetch username from Firestore
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _fetchStepData(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();
    if (Platform.isAndroid) {
      if (!await Permission.activityRecognition.isGranted) {
        await Permission.activityRecognition.request();
      }
    }
    await _fetchStepData();
  }

  Future<void> _fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
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

  /// Fetch today's steps and distance
  Future<void> _fetchStepData() async {
    await _health.configure(); // required for health: ^13.x.x

    final types = [HealthDataType.STEPS, HealthDataType.DISTANCE_DELTA];

    bool granted = await _health.requestAuthorization(types);
    if (!granted) {
      debugPrint("Permission not granted to read steps and distance.");
      return;
    }

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    // Steps (shortcut API)
    int? steps = await _health.getTotalStepsInInterval(midnight, now);

    // Try to get distance using multiple approaches
    double totalDistance = 0.0;

    // Approach 1: Try getting distance data points
    try {
      List<HealthDataPoint> distanceData = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: [HealthDataType.DISTANCE_DELTA],
      );

      debugPrint("Found ${distanceData.length} distance data points");

      for (var point in distanceData) {
        var value = point.value;
        if (value is NumericHealthValue) {
          totalDistance += value.numericValue.toDouble();
          debugPrint("Added distance: ${value.numericValue}");
        }
      }
    } catch (e) {
      debugPrint("Error fetching distance data: $e");
    }

    // Approach 2: If no distance found, try estimating from steps (rough approximation)
    if (totalDistance == 0.0 && steps != null && steps > 0) {
      // Average step length is approximately 0.8 meters
      totalDistance = steps * 0.8;
      debugPrint("Estimated distance from steps: $totalDistance meters");
    }

    debugPrint("Final total distance: $totalDistance meters");

    setState(() {
      _totalSteps = steps ?? 0;
      _totalDistance = totalDistance; // in meters
    });
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
        backgroundColor: const Color.fromRGBO(99, 75, 102, 1),
        centerTitle: true,
        title: Text(
          "HOME",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/profile',
              ); // Go to profile page
            },
          ),
        ],
      ),

      // --- Body content ---
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Welcome, $_username!", // Displays username
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          // Step tracking section
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.blueGrey[100],
            child: Center(
              child: Text(
                "Steps: $_totalSteps",
                style: TextStyle(fontSize: 18, color: Colors.blueGrey[800]),
              ),
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.blueGrey[100],
            child: Center(
              child: Text(
                "Distance: ${(_totalDistance / 1000).toStringAsFixed(2)} km",
                style: TextStyle(fontSize: 18, color: Colors.blueGrey[800]),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _fetchStepData,
            child: const Text("Refresh Step Data"),
          ),
          // Rest of the body (expandable area for future content)
          Expanded(child: Container()),
        ],
      ),

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(99, 75, 102, 1),
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(24, 2, 12, 1),
        unselectedItemColor: const Color.fromRGBO(149, 144, 168, 1),
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
            Navigator.pushReplacementNamed(
              context,
              '/mental',
            ); // Navigate to mental
          } else {
            _onItemTapped(index); // Switch to home or dashboard tab
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Mental',
          ),
        ],
      ),
    );
  }
}
