import 'package:flutter/material.dart';

class PlanTripPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Plan Your Trip',
        style: TextStyle(color: Colors.white), ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Color.fromARGB(255, 33, 37, 41),
      body: Center(
        child: Text(
          'Trip planning screen will go here',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
