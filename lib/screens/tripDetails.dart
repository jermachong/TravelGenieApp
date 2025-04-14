import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_first_app/utils/getAPI.dart'; // Update the path as necessary
import 'package:my_first_app/screens/savedTrips.dart'; // Import SavedTripsPage

class TripDetailsPage extends StatelessWidget {
  final Map<String, dynamic> trip;

  TripDetailsPage({required this.trip});

  Future<void> deleteTrip(BuildContext context) async {
    final userId = GlobalData.userId;
    final itineraryId = trip['itineraryId']; // Use the itineraryId directly from the trip object

    if (userId == null || itineraryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Missing userId or itineraryId')),
      );
      return;
    }

    final payload = {
      'userId': userId,
      'itineraryId': itineraryId,
    };

    try {
      final response = await http.post(
        Uri.parse('http://164.92.126.28:5000/api/deleteItinerary'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );

        // Navigate back to SavedTripsPage and refresh
        Navigator.pop(context, true); // Pass `true` to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['error'] ?? 'Failed to delete trip')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<Map<String, dynamic>?> fetchItineraryDetails(BuildContext context) async {
    final userId = GlobalData.userId;
    final itineraryName = trip['Itinerary']['title']; // Use the title to search

    if (userId == null || itineraryName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Missing userId or itinerary name')),
      );
      return null;
    }

    final payload = {
      'userId': userId,
      'itineraryName': itineraryName,
    };

    try {
      final response = await http.post(
        Uri.parse('http://164.92.126.28:5000/api/searchItinerary'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['Itineraries'] != null && responseData['Itineraries'].isNotEmpty) {
          final itinerary = responseData['Itineraries'][0];
          print('Fetched itinerary details: $itinerary'); // Debugging
          return itinerary; // Return the full itinerary object
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Itinerary not found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch itinerary details')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }

    return null;
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
        iconTheme: IconThemeData(color: Colors.white),
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

                // Quick Details Section
                Card(
                  color: Colors.grey[850],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.orangeAccent),
                            SizedBox(width: 8),
                            Text(
                              'Duration: ${itinerary['duration'] ?? 'N/A'} days',
                              style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.blueAccent),
                            SizedBox(width: 8),
                            Text(
                              'Destination(s): ${itinerary['destination'] ?? 'Unknown'}',
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
                              'People: ${itinerary['groupSize'] ?? 'N/A'}',
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
                              'Budget: \$${itinerary['price'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                Builder(
                  builder: (safeContext) => Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: safeContext,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              backgroundColor: Color.fromARGB(255, 33, 37, 41),
                              title: Text('Confirm Delete', style: TextStyle(color: Colors.white)),
                              content: Text(
                                'Are you sure you want to delete this trip?',
                                style: TextStyle(color: Colors.white70),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop(); // close dialog
                                  },
                                  child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(dialogContext).pop(); // close dialog 
                                    await deleteTrip(safeContext); // delete
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: Text('Delete', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.white),
                      label: Text('Delete Trip', style: TextStyle(color: Colors.white)),
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