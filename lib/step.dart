import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:health/health.dart';

class StepTracker extends StatefulWidget {
  const StepTracker({super.key});

  @override
  State<StepTracker> createState() => _StepTrackerState();
}

class _StepTrackerState extends State<StepTracker> {
  final Health _health = Health(); // health: ^13.x.x
  int _totalSteps = 0;
  double _totalDistance = 0.0; // meters
  double _totalCalories = 0.0; // kcal
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Request runtime permissions
  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      if (!await Permission.activityRecognition.isGranted) {
        await Permission.activityRecognition.request();
      }
    }
    await _fetchData();
  }

  /// Fetch today's steps and distance
  Future<void> _fetchData() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(192, 204, 218, 1),
        centerTitle: true,
        title: const Text(
          "STEP & DISTANCE TRACKER",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.blueGrey,
          ),
        ),
      ),

      body: Column(
        children: [
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
          TextButton(onPressed: _fetchData, child: const Text("Refresh Data")),
        ],
      ),
    );
  }
}
