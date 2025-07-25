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

      body: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(66, 76, 90, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/workout');
                    }, 
                    child: const Text("WORKOUT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white
                      )
                    )),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(66, 76, 90, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/steps');
                    }, 
                    child: const Text("STEPS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white
                      )
                    )),
                ),
              ],
            )
            
          )
        ],
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
