import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:my_first_app/utils/getAPI.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/screens/tripDetails.dart'; // Update the path if necessary

// class GlobalData {
//   static int userId = 82;
//   static String firstName = "R";
//   static String lastName = "4331";
//   static String email = "r@example.com";
//   static String password = "********";
// }

class SavedTripsPage extends StatefulWidget {
  @override
  _SavedTripsPageState createState() => _SavedTripsPageState();
}

class _SavedTripsPageState extends State<SavedTripsPage> {
  String statusMessage = '';
  List<dynamic> savedTrips = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    print('GlobalData.userId: ${GlobalData.userId}');
    _refreshUserInfo();
    fetchSavedTrips();
  }

  Future<void> _refreshUserInfo() async {
    try {
      String url = 'http://164.92.126.28:5000/api/get-user';
      String payload = json.encode({ "userId": GlobalData.userId });
      String response = await CardsData.getJson(url, payload);
      var jsonObject = json.decode(response);

      setState(() {
        GlobalData.userId = jsonObject["userId"]; // Update userId
        GlobalData.firstName = jsonObject["firstName"];
        GlobalData.lastName = jsonObject["lastName"];
        GlobalData.email = jsonObject["email"];
      });

      print('User info refreshed. UserId: ${GlobalData.userId}');
    } catch (e) {
      print("Error loading user info: $e");
    }
  }

  Future<void> fetchSavedTrips() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final userId = GlobalData.userId.toString();
      final payload = {
        'userId': userId,
        'itineraryName': '',
      };

      print('Request payload: $payload');

      final response = await http.post(
        Uri.parse('http://164.92.126.28:5000/api/searchItinerary'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final itineraries = data['Itineraries'];
        //print('Fetched itineraries: $itineraries'); // Debug the fetched data
        setState(() {
          savedTrips = itineraries.map((trip) {
            final itinerary = trip['Itinerary'];
            itinerary['image'] = itinerary['image']?.startsWith('http') == true
                ? itinerary['image']
                : null; // Set to null if the URL is invalid
            return trip;
          }).toList();
        });
        //print('Saved trips: $savedTrips');
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          errorMessage = errorData['error'] ?? 'Failed to fetch saved trips. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
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
      appBar: AppBar(
        title: Text(
          'Saved Trips',
          style: TextStyle(color: Colors.white), // Set the title font color to white
        ),
        backgroundColor: Colors.black, // Keep the background color black
        iconTheme: IconThemeData(color: Colors.white), // Set the icon color to white
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuOption,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'Change Name', child: Text('Change Name')),
                PopupMenuItem(value: 'Change Email', child: Text('Change Email')),
                PopupMenuItem(value: 'Change Password', child: Text('Change Password')),
                PopupMenuItem(value: 'Logout', child: Text('Logout')),
              ];
            },
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 33, 37, 41),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : savedTrips.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No saved trips found.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: savedTrips.length,
                            itemBuilder: (context, index) {
                              final trip = savedTrips[index]['Itinerary'];
                              final title = trip['title'] ?? 'No Title';
                              final description = trip['description'] ?? 'No Description';

                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                leading: trip['image'] != null && trip['image'].isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          trip['image'],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(Icons.broken_image, color: Colors.grey, size: 50);
                                          },
                                        ),
                                      )
                                    : Icon(Icons.image, color: Colors.grey, size: 50),
                                title: Text(
                                  title,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      description,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      'Destination: ${trip['destination'] ?? 'Unknown'}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      'Price: \$${trip['price'] ?? 'N/A'}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  print('Navigating to TripDetailsPage with trip: ${savedTrips[index]}');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TripDetailsPage(trip: savedTrips[index]),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/plan-trip').then((_) {
            fetchSavedTrips(); // Refresh saved trips when returning
          });
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white), // Plus icon
      ),
    );
  }
}