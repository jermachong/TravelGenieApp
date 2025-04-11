import 'package:flutter/material.dart';
import 'package:my_first_app/utils/getAPI.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String loginName = ''; 
  String password = ''; 
  String newMessageText = ''; 

  void changeText() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white), 
        title: Text('Login', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Color.fromARGB(255, 33, 37, 41),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Login Name',
                  hintText: 'Enter Your Login Name',
                ),
                onChanged: (text) {
                  setState(() {
                    loginName = text;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter Your Password',
                ),
                onChanged: (text) {
                  setState(() {
                    password = text;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[50],
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                ),
                child: Text('Login', style: TextStyle(fontSize: 14, color: Colors.black)),
                onPressed: () async {
                  newMessageText = "";
                  changeText();

                  String payload = '{"login":"' + loginName.trim() + '","password":"' + password.trim() + '"}';
                  var userId = -1;
                  var jsonObject;

                  try {
                    String url = 'http://164.92.126.28:5000/api/login';                  
                    String ret = await CardsData.getJson(url, payload);
                    jsonObject = json.decode(ret);
                    userId = jsonObject["userId"] ?? -1;
                  } catch (e) {
                    newMessageText = e.toString();
                    changeText();
                    return;
                  }

                  if (userId <= 0) {
                    newMessageText = "Incorrect Login/Password";
                    changeText();
                  } else {
                    GlobalData.userId = userId;
                    GlobalData.firstName = jsonObject["firstName"];
                    GlobalData.lastName = jsonObject["lastName"];
                    GlobalData.loginName = loginName;
                    GlobalData.password = password;

                    Navigator.pushNamed(context, '/saved-trips');
                  }
                },
              ),
              SizedBox(height: 16.0),
              Text(
                newMessageText,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  side: BorderSide(color: Colors.blueAccent),
                  foregroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/cards');
                },
                child: Text("Create Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}