import 'package:flutter/material.dart';

class SavedTripsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 37, 41),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Saved Trips', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Text(
          'No saved trips yet.',
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
      ),
    );
  }
}
