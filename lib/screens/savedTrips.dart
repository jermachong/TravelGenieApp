import 'package:flutter/material.dart';

class SavedTripsPage extends StatefulWidget {
  @override
  _SavedTripsPageState createState() => _SavedTripsPageState();
}

class _SavedTripsPageState extends State<SavedTripsPage> {
  void _handleMenuOption(String value) {
    switch (value) {
      case 'Change Name':
        print('Change Name selected');
        break;
      case 'Change Email':
        print('Change Email selected');
        break;
      case 'Change Password':
        print('Change Password selected');
        break;
      case 'Logout':
        Navigator.pushNamed(context, '/login');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 37, 41),
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
          'No saved trips yet.',
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
      ),
    );
  }
}
