import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:my_first_app/utils/getAPI.dart';

class GlobalData {
  static int userId = 82;
  static String firstName = "R";
  static String lastName = "4331";
  static String email = "r@example.com";
  static String password = "********";
}

class SavedTripsPage extends StatefulWidget {
  @override
  _SavedTripsPageState createState() => _SavedTripsPageState();
}

class _SavedTripsPageState extends State<SavedTripsPage> {
  String statusMessage = '';

  @override
  void initState() {
    super.initState();
    _refreshUserInfo();
  }

  Future<void> _refreshUserInfo() async {
    try {
      String url = 'http://164.92.126.28:5000/api/get-user';
      String payload = json.encode({ "userId": GlobalData.userId });
      String response = await CardsData.getJson(url, payload);
      var jsonObject = json.decode(response);
      setState(() {
        GlobalData.firstName = jsonObject["firstName"];
        GlobalData.lastName = jsonObject["lastName"];
        GlobalData.email = jsonObject["email"];
      });
    } catch (e) {
      print("Error loading user info: $e");
    }
  }

  void _handleMenuOption(String value) {
    switch (value) {
      case 'Change Name':
        _showNameEditDialog();
        break;
      case 'Change Email':
        _showUpdateDialog(
          title: 'Change Email',
          currentValue: GlobalData.email,
          label: 'New email',
          onSave: (newValue) async {
            await editUser(email: newValue.trim());
            setState(() => statusMessage = 'Email updated!');
          },
        );
        break;
      case 'Change Password':
        _showUpdateDialog(
          title: 'Change Password',
          currentValue: '********',
          label: 'New password',
          isObscure: true,
          onSave: (newValue) async {
            await editUser(password: newValue.trim());
            setState(() => statusMessage = 'Password updated!');
          },
        );
        break;
      case 'Logout':
        Navigator.pushNamed(context, '/login');
        break;
    }
  }

  void _showNameEditDialog() {
    String newFirstName = GlobalData.firstName;
    String newLastName = GlobalData.lastName;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 33, 37, 41), //Color(0xFF2C2C33),
        title: Text("Change Name", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (val) => newFirstName = val,
              controller: TextEditingController(text: GlobalData.firstName),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              onChanged: (val) => newLastName = val,
              controller: TextEditingController(text: GlobalData.lastName),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              await editUser(firstName: newFirstName, lastName: newLastName);
              setState(() => statusMessage = 'Name updated!');
              Navigator.of(context).pop();
            },
            child: Text('Save', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog({
    required String title,
    required String currentValue,
    required String label,
    required Function(String) onSave,
    bool isObscure = false,
  }) {
    String newValue = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 33, 37, 41), //Color(0xFF2C2C33),
        title: Text(title, style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Current: $currentValue", style: TextStyle(color: Colors.white70)),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: isObscure,
              onChanged: (val) => newValue = val,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              onSave(newValue);
              Navigator.of(context).pop();
            },
            child: Text('Save', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  Future<void> editUser({String? firstName, String? lastName, String? email, String? password}) async {
    try {
      String url = 'http://164.92.126.28:5000/api/editUser';
      Map<String, dynamic> payload = {
        "userId": GlobalData.userId,
      };

      if (firstName != null) payload["firstName"] = firstName;
      if (lastName != null) payload["lastName"] = lastName;
      if (email != null) payload["email"] = email;
      if (password != null) payload["password"] = password;

      String response = await CardsData.getJson(url, json.encode(payload));
      var result = json.decode(response);
      print("EditUser response: $result");

      if (firstName != null) GlobalData.firstName = firstName;
      if (lastName != null) GlobalData.lastName = lastName;
      if (email != null) GlobalData.email = email;
      if (password != null) GlobalData.password = password;
    } catch (e) {
      print("Error editing user: $e");
      setState(() => statusMessage = "Error: Could not update");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 37, 41), //Color(0xFF28242C),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Saved Trips', style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.settings, color: Colors.white),
            onSelected: _handleMenuOption,
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Change Name', child: Text('Change Name')),
              PopupMenuItem(value: 'Change Email', child: Text('Change Email')),
              PopupMenuItem(value: 'Change Password', child: Text('Change Password')),
              PopupMenuItem(value: 'Logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: Center(
        child: Text(
          statusMessage.isEmpty ? 'No saved trips yet.' : statusMessage,
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
      ),
    );
  }
}