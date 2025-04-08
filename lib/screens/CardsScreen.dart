import 'package:flutter/material.dart';
import 'package:my_first_app/utils/getAPI.dart';
import 'dart:convert';

class CardsScreen extends StatefulWidget {
  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String login = '';
  String password = '';
  String statusMessage = '';

  void updateMessage(String message) {
    setState(() {
      statusMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 37, 41),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Create Account', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Container(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInput('First Name', (val) => firstName = val),
                _buildInput('Last Name', (val) => lastName = val),
                _buildInput('Email', (val) => email = val),
                _buildInput('Login', (val) => login = val),
                _buildInput('Password', (val) => password = val, obscure: true),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    updateMessage('');
                    String payload = json.encode({
                      "userId": GlobalData.userId.toString(),
                      "firstName": firstName.trim(),
                      "lastName": lastName.trim(),
                      "email": email.trim(),
                      "login": login.trim(),
                      "password": password.trim(),
                    });

                    try {
                      String url = 'http://164.92.126.28:5000/api/register';
                      String ret = await CardsData.getJson(url, payload);
                      var jsonObject = json.decode(ret);
                      updateMessage('User has been added!');
                    } catch (e) {
                      updateMessage(e.toString());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text('Create Account'),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: Text('Back to Login', style: TextStyle(color: Colors.white70)),
                ),
                SizedBox(height: 16),
                Text(
                  statusMessage,
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, Function(String) onChanged, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        obscureText: obscure,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.grey[850],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
