import 'package:flutter/material.dart';
import 'package:health/health.dart';

class StepTracker extends StatefulWidget {
  const StepTracker({super.key});

  @override
  State<StepTracker> createState() => _StepTrackerState();
}

class _StepTrackerState extends State<StepTracker> {
  int _totalSteps = 0;
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Global Health instance
    final health = Health();

    // configure the health plugin before use.
    await health.configure();

    // define the types to get
    var types = [HealthDataType.STEPS];

    // requesting access to the data types before reading them
    bool requested = await health.requestAuthorization(types);

    var now = DateTime.now();

    // fetch health data from the last 24 hours
    /*List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
      now.subtract(Duration(days: 1)),
      now,
      types,
    );*/

    // get the number of steps for today
    var midnight = DateTime(now.year, now.month, now.day);
    int? steps = await health.getTotalStepsInInterval(midnight, now);
    setState(() {
      _totalSteps = steps ?? 0;
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
          "STEP TRACKER",
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
          SizedBox(
            height: 50,
            child: Container(
              color: Colors.blueGrey[100],
              child: Center(
                child: Text(
                  "Steps: $_totalSteps",
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey[800]),
                ),
              ),
            ),
          ),
          TextButton(onPressed: () {}, child: const Text("Start Tracking")),
        ],
      ),
    );
  }
}
