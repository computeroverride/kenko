import 'package:flutter/material.dart';


class LogAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading:  Icon(Icons.rice_bowl),
            title: Text("Food and Water"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/food&water');
            },
          ),
          ListTile(
            leading: Icon(Icons.local_activity),
            title: Text("Activity Log"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/activity');
            },
          )
        ],
      ),
    );
  }
}
