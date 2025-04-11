import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

dynamic itinerary; // Placeholder for itinerary data

class PlanTripPage extends StatefulWidget {
  @override
  _PlanTripPageState createState() => _PlanTripPageState();
}

class _PlanTripPageState extends State<PlanTripPage> {
  final _destinationController = TextEditingController();
  final _durationController = TextEditingController();
  final _groupSizeController = TextEditingController();
  final _preferencesController = TextEditingController();

  bool showPlaceholder = false;
  dynamic itinerary = '';
  String errorMessage = '';
  bool isLoading = false;

  Future<void> generateItinerary() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      itinerary = null; // Reset itinerary to null
    });

    try {
      final duration = int.tryParse(_durationController.text) ?? 0;
      final groupSize = int.tryParse(_groupSizeController.text) ?? 0;

      final tripData = {
        'destination': _destinationController.text.trim(),
        'duration': duration,
        'groupSize': groupSize,
        'preferences': _preferencesController.text.trim(),
      };

      print('Sending trip data: ${jsonEncode(tripData)}'); // Debugging line

      final response = await http.post(
        Uri.parse('http://164.92.126.28:5000/api/generate-itinerary'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tripData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data'); // Debugging line

        setState(() {
          itinerary = data; // Store the entire JSON object
          showPlaceholder = true;
        });
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          errorMessage = errorData['error'] ?? 'Failed to generate itinerary. Please try again.';
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

  Future<void> saveTrip() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Replace with actual logic to retrieve the userId and jwtToken
      final userId = "12345"; // Replace with the actual user ID
      final jwtToken = "your_jwt_token"; // Replace with the actual JWT token

      if (userId.isEmpty || jwtToken.isEmpty) {
        Navigator.pushReplacementNamed(context, '/login'); // Replace '/login' with your login route
        return;
      }

      final response = await http.post(
        Uri.parse('http://164.92.126.28:5000/api/addItinerary'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'itinerary': itinerary,
          'jwtToken': jwtToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final itineraryId = data['ItineraryId']; // Extract ItineraryId from the response
        if (itineraryId != null) {
          print('Trip saved successfully: $itineraryId');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trip saved successfully!')),
          );
        } else {
          print('Trip saved successfully, but no ItineraryId was returned.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trip saved successfully, but no ID was returned.')),
          );
        }
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          errorMessage = errorData['error'] ?? 'Failed to save trip. Please try again.';
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

  @override
  Widget build(BuildContext context) {
    // Replace with actual logic to check if the user is logged in
    final userId = "12345"; // Replace with the actual user ID
    final jwtToken = "your_jwt_token"; // Replace with the actual JWT token

    if (userId.isEmpty || jwtToken.isEmpty) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login'); // Replace '/login' with your login route
      });
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 37, 41),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Travel Plan', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Destination', _destinationController),
            Row(
              children: [
                Expanded(child: _buildTextField('Duration (days)', _durationController)),
                SizedBox(width: 12),
                Expanded(child: _buildTextField('Group Size', _groupSizeController)),
              ],
            ),
            _buildTextField('Preferences', _preferencesController),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : generateItinerary,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Generate Itinerary'),
            ),
            if (errorMessage.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
            if (showPlaceholder && itinerary != null) ...[
              SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itinerary['title'] ?? 'No title available',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      itinerary['description'] ?? 'No description available',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: isLoading || itinerary == null ? null : saveTrip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Save Trip'),
                    ),
                  ],
                ),
              ),
            ] else if (showPlaceholder) ...[
              Text(
                'No itinerary generated yet.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.grey[850],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => LoginPage(),
      '/plan-trip': (context) => PlanTripPage(),
    },
  ));
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Text('Login Page'),
      ),
    );
  }
}
