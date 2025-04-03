import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                setState(() {
                  showPlaceholder = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: Text('Generate Itinerary'),
            ),

            // Result Section
            if (showPlaceholder) ...[
              SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Itinerary will go here',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
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
