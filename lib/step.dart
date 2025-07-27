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
  final Health _health = Health(); // ✅ correct for health: ^13.x.x
  int _totalSteps = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchSteps());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Requests ACTIVITY_RECOGNITION runtime permission (Android 10+)
  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      var status = await Permission.activityRecognition.status;
      if (!status.isGranted) {
        await Permission.activityRecognition.request();
      }
    }
    await _fetchSteps();
  }

  /// Fetch today's steps from Health Connect / Google Fit
  Future<void> _fetchSteps() async {
    final types = [HealthDataType.STEPS];
    bool granted = await _health.requestAuthorization(types);

    if (!granted) {
      debugPrint("Permission not granted to read steps.");
      return;
    }

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    int? steps = await _health.getTotalStepsInInterval(midnight, now);
    setState(() {
      _totalSteps = steps ?? 0;
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
          "STEP TRACKER",
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
          TextButton(
            onPressed: _fetchSteps,
            child: const Text("Refresh Steps"),
          ),
        ],
      ),
    );
  }
}
