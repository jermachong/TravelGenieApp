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
    final userId = GlobalData.userId;
    final itineraryId = trip['Itinerary']['itineraryId'];

    print('TripDetailsPage received userId: $userId, itineraryId: $itineraryId');

    return Scaffold(
      appBar: AppBar(
        title: Text(itinerary['title'] ?? 'Trip Details', style: TextStyle(color: Colors.white)),
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

                // Daily Breakdown
                ...dailyBreakdown.map<Widget>((day) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Day Header
                      Text(
                        'Day ${day['day']}: ${day['date'] ?? ''}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      SizedBox(height: 8),

                      // Activities List
                      ...day['activities'].map<Widget>((activity) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon
                                Icon(Icons.location_on, color: Colors.blueAccent, size: 24),
                                SizedBox(width: 12),

                                // Activity Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activity['activity'] ?? 'No Activity',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${activity['time'] ?? ''} - ${activity['location'] ?? ''}',
                                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        activity['details'] ?? '',
                                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),

                                // Action Button
                                if (activity['action'] != null)
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle button action
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                    ),
                                    child: Text(activity['action'] ?? 'Action'),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),

                // Delete Trip Button
                SizedBox(height: 16),
                Center(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}