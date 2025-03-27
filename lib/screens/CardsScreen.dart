import 'package:flutter/material.dart';
import 'package:my_first_app/utils/getAPI.dart';
import 'dart:convert';

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
  String card = ''; // To store the card input
  String search = ''; // To store the search input
  String firstName = ''; // To store the first name input
  String lastName = ''; // To store the last name input
  String email = ''; // To store the email input
  String login = ''; // To store the login input
  String password = ''; // To store the password input
  String newAddMessage = ''; // To display messages for adding cards
  String newSearchMessage = ''; // To display messages for searching cards

  // Method to update the add card message
  void changeAddText() {
    setState(() {
      // Update the UI with the new add message
    });
  }

  // Method to update the search message
  void changeSearchText() {
    setState(() {
      // Update the UI with the new search message
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
          // Search Row
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
                  onChanged: (text) {
                    search = text; // Update the search input as the user types
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
                onPressed: () async {
                  newSearchMessage = "";
                  changeSearchText();

                  String payload = '{"userId":"' + GlobalData.userId.toString() + '","search":"' + search.trim() + '"}';

                  var jsonObject;
                  try {
                    String url = 'http://164.92.126.28:5000/api/search';
                    String ret = await CardsData.getJson(url, payload);
                    jsonObject = json.decode(ret);
                  } catch (e) {
                    newSearchMessage = e.toString();
                    changeSearchText();
                    return;
                  }

                  var results = jsonObject["results"];
                  var i = 0;
                  while (true) {
                    try {
                      newSearchMessage += results[i];
                      newSearchMessage += "\n";
                      i++;
                    } catch (e) {
                      break;
                    }
                  }

                  changeSearchText();
                },
              ),
            ],
          ),
          SizedBox(height: 16.0), // Add spacing between rows

          // Add Card Row
          Row(
            children: <Widget>[
              Container(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                    hintText: 'Enter First Name',
                  ),
                  onChanged: (text) {
                    firstName = text; // Update the first name input as the user types
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0), // Add spacing between fields
          Row(
            children: <Widget>[
              Container(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                    hintText: 'Enter Last Name',
                  ),
                  onChanged: (text) {
                    lastName = text; // Update the last name input as the user types
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0), // Add spacing between fields
          Row(
            children: <Widget>[
              Container(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter Email',
                  ),
                  onChanged: (text) {
                    email = text; // Update the email input as the user types
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0), // Add spacing between fields
          Row(
            children: <Widget>[
              Container(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Login',
                    hintText: 'Enter Login',
                  ),
                  onChanged: (text) {
                    login = text; // Update the login input as the user types
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0), // Add spacing between fields
          Row(
            children: <Widget>[
              Container(
                width: 200,
                child: TextField(
                  obscureText: true, // Hide password input
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter Password',
                  ),
                  onChanged: (text) {
                    password = text; // Update the password input as the user types
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0), // Add spacing between rows
          Row(
            children: <Widget>[
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
                onPressed: () async {
                  newAddMessage = "";
                  changeAddText();

                  // Updated payload to include firstName, lastName, email, login, and password
                  String payload = json.encode({
                    "userId": GlobalData.userId.toString(),
                    "firstName": firstName.trim(),
                    "lastName": lastName.trim(),
                    "email": email.trim(),
                    "login": login.trim(),
                    "password": password.trim(),
                  });

                  var jsonObject;
                  try {
                    String url = 'http://164.92.126.28:5000/api/register';
                    String ret = await CardsData.getJson(url, payload);
                    jsonObject = json.decode(ret);
                  } catch (e) {
                    newAddMessage = e.toString();
                    changeAddText();
                    return;
                  }

                  newAddMessage = "User has been added";
                  changeAddText();
                },
              ),
            ],
          ),
          SizedBox(height: 16.0), // Add spacing between rows

          // Logout Button Row
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
          SizedBox(height: 16.0), // Add spacing between rows

          // Display Add Message
          Row(
            children: <Widget>[
              Text(
                '$newAddMessage', // Display the add card message
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 16.0), // Add spacing between rows

          // Display Search Results
          Row(
            children: <Widget>[
              Text(
                '$newSearchMessage', // Display the search results
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}