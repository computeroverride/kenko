import 'package:flutter/material.dart';
import 'package:kenko/logadd.dart';

class WorkoutLog extends StatefulWidget {
@override
  State<WorkoutLog> createState() => _WorkoutLogState();
}

class _WorkoutLogState extends State<WorkoutLog> {
  int _selectedIndex = 0; 
  final _workoutNameController = TextEditingController();
  final _workoutValueController = TextEditingController();
  final String selectedUnit = 'Reps';
  final List<String> units = ['Reps', 'Minutes'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(192, 204, 218, 1),
        centerTitle: true,
        title: Text("ADD TO ACTIVITY LOG",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: const Color.fromRGBO(66, 76, 90, 1),
        )),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    TextField(
                      controller: _workoutNameController,
                      decoration: const InputDecoration(
                        hintText: "Workout Name",
                        border: InputBorder.none
                      ),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      value: selectedUnit,
                      items: units.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                    );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        newValue!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Workout Type",
                      border: OutlineInputBorder(),
                    ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _workoutValueController,
                      decoration: const InputDecoration(
                        hintText: "Value",
                        border: InputBorder.none
                      ),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(66, 76, 90, 1),
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: const Text("ADD",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        )),
                    )

                  ],
                ))
            ],
          ),
        )
      ),

      bottomNavigationBar: BottomNavigationBar (
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(66, 76, 90, 1),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 2) {
            showModalBottomSheet(
              context: context, 
              backgroundColor: Colors.white,
              builder: (context) => LogAdd());
          }
          else if (index == 0){
            Navigator.pushReplacementNamed(context,'/home');
          }
          else if (index == 3){
            Navigator.pushReplacementNamed(context, '/map');
          }
          else if (index == 4){
            Navigator.pushReplacementNamed(context, '/mental');
          }
          else {
            _onItemTapped(index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Mental')
        ],
      ),
    );
  }
}