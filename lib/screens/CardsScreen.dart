import 'package:flutter/material.dart';
import 'package:my_first_app/utils/getAPI.dart';

class CardsScreen extends StatefulWidget {
  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String message = "This is a message"; // Initial message
  String newMessageText = ''; // Text to update the message

  // Method to update the message
  void changeText() {
    setState(() {
      message = newMessageText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center Column contents vertically
        crossAxisAlignment: CrossAxisAlignment.center, // Center Column contents horizontally
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Search',
                    hintText: 'Search for a Card',
                  ),
                  onChanged: (value) {
                    newMessageText = value; // Update newMessageText as the user types
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[50], // Background color
                  foregroundColor: Colors.black,    // Text color
                  padding: EdgeInsets.all(2.0),     // Button padding
                ),
                child: Text(
                  'Search',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                onPressed: () {
                  changeText(); // Update the message when the button is pressed
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 200,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Add',
                    hintText: 'Add a Card',
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[50], // Background color
                  foregroundColor: Colors.black,    // Text color
                  padding: EdgeInsets.all(2.0),     // Button padding
                ),
                child: Text(
                  'Add',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                onPressed: () {
                  // Add functionality to add a card here
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[50], // Background color
                  foregroundColor: Colors.black,    // Text color
                  padding: EdgeInsets.all(2.0),     // Button padding
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login'); // Navigate to the Login screen
                },
              ),
            ],
          ),
          SizedBox(height: 16.0), // Add spacing between the rows
          Row(
            children: <Widget>[
              Text(
                '$message', // Display the message
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}