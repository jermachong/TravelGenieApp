import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_first_app/utils/getAPI.dart'; // Update the path as necessary

class TripDetailsPage extends StatelessWidget {
  final Map<String, dynamic> trip;

  TripDetailsPage({required this.trip});

  Future<void> deleteTrip(BuildContext context) async {
    final userId = GlobalData.userId; // Use GlobalData.userId
    final itineraryName = trip['Itinerary']['title']; // Use the itinerary name instead of itineraryId

    if (userId == null || itineraryName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Missing userId or itinerary name')),
      );
      return;
    }

    final payload = {
      'userId': userId,
      'itineraryName': itineraryName, // Use itineraryName as required by the API
    };

    try {
      final response = await http.post(
        Uri.parse('http://164.92.126.28:5000/api/deleteItinerary'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['message'] != null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        Navigator.pop(context); // Go back to the previous screen
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['error'] ?? 'Failed to delete trip')),
        );
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final itinerary = trip['Itinerary'];
    final dailyBreakdown = itinerary['dailyBreakdown'] ?? [];
    final userId = GlobalData.userId; // Use GlobalData.userId
    final itineraryId = trip['Itinerary']['itineraryId'];

    print('TripDetailsPage received userId from GlobalData: $userId, itineraryId: $itineraryId');

    return Scaffold(
      appBar: AppBar(
        title: Text(itinerary['title'] ?? 'Trip Details'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip Image with Hero Animation
                itinerary['image'] != null && itinerary['image'].isNotEmpty
                    ? Hero(
                        tag: itinerary['title'] ?? 'trip-image',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            itinerary['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image, color: Colors.grey, size: 100);
                            },
                          ),
                        ),
                      )
                    : Icon(Icons.image, color: Colors.grey, size: 100),
                SizedBox(height: 16),

                // Trip Summary
                Text(
                  itinerary['title'] ?? 'No Title',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  itinerary['description'] ?? 'No Description',
                  style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                ),
                SizedBox(height: 16),

                // Trip Details with Icons
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text(
                      'Destination: ${itinerary['destination'] ?? 'Unknown'}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.greenAccent),
                    SizedBox(width: 8),
                    Text(
                      'Price: \$${itinerary['price'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.orangeAccent),
                    SizedBox(width: 8),
                    Text(
                      'Duration: ${itinerary['duration']} days',
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.group, color: Colors.purpleAccent),
                    SizedBox(width: 8),
                    Text(
                      'Group Size: ${itinerary['groupSize']} people',
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Daily Breakdown
                Text(
                  'Daily Breakdown:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                ...dailyBreakdown.map<Widget>((day) {
                  return Card(
                    color: Colors.grey[850],
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Day ${day['day']}:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 8),
                          ...day['activities'].map<Widget>((activity) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${activity['time']} - ${activity['activity']} (${activity['location']})\nDetails: ${activity['details']}',
                                      style: TextStyle(fontSize: 14, color: Colors.grey[300]),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                // Delete Trip Button
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () => deleteTrip(context),
                      icon: Icon(Icons.delete, color: Colors.white),
                      label: Text(
                        'Delete Trip',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}