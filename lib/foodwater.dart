// ill actly do it once the profile is moved to the top right -marjana

import 'package:flutter/material.dart';
import 'package:kenko/logadd.dart';


class FoodWaterLog extends StatefulWidget {
  const FoodWaterLog({super.key});

  @override
  State<FoodWaterLog> createState() => _FoodWaterLogState();
}

class _FoodWaterLogState extends State<FoodWaterLog> {
  int _selectedIndex = 0; 
    final _foodNameController = TextEditingController();
    final _caloriesController = TextEditingController();
    final _glassesController = TextEditingController();

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
        title: Text("ADD TO FOOD AND WATER LOG",
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
                      controller: _foodNameController,
                      decoration: const InputDecoration(
                        hintText: "Food Name",
                        border: InputBorder.none
                      ),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _caloriesController,
                      decoration: const InputDecoration(
                        hintText: "Calories",
                        border: InputBorder.none
                      ),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _glassesController,
                      decoration: const InputDecoration(
                        hintText: "Glasses of Water",
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
                )
              ),
                
            ],
          ),
        )),


      bottomNavigationBar: BottomNavigationBar (
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(66, 76, 90, 1),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 2) {
            showModalBottomSheet(context: context, builder: (context) => LogAdd());
          }
          else if (index == 0){
            Navigator.pushReplacementNamed(context,'/home');
          }
          else if (index == 3){
            Navigator.pushReplacementNamed(context, '/map');
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