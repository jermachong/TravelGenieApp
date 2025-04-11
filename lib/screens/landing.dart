import 'package:flutter/material.dart';
import 'package:my_first_app/utils/getAPI.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 37, 41),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          'TravelGenie',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              if (value == 'login') {
                Navigator.pushNamed(context, '/login');
              } else if (value == 'create') {
                Navigator.pushNamed(context, '/cards');
              } else if (value == 'saved') {
                Navigator.pushNamed(context, '/saved-trips');
              } else if (value == 'logout') {
                GlobalData.loggedIn = false;
                Navigator.pushReplacementNamed(context, '/landing');
              }
            },
            itemBuilder: (context) {
              if (GlobalData.loggedIn) {
                return [
                  PopupMenuItem<String>(
                    value: 'saved',
                    child: Text('Saved Trips'),
                  ),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ];
              } else {
                return [
                  PopupMenuItem<String>(
                    value: 'login',
                    child: Text('Login'),
                  ),
                  PopupMenuItem<String>(
                    value: 'create',
                    child: Text('Create Account'),
                   ),
                ];
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'TravelGenie',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Your ultimate travel companion that makes planning trips effortless, coordinates group adventures, and helps you discover amazing places to eat.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (GlobalData.loggedIn) {
                  Navigator.pushNamed(context, '/plan-trip');
                } else {
                  Navigator.pushNamed(context, '/cards'); // route to create account
                }
              },
              child: Text('Start Planning'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 32),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/travel_image.jpg',
                fit: BoxFit.cover,
              ),
            ),

            // feature cards 
            SizedBox(height: 48),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Everything you need to plan your perfect adventure',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildFeatureCard(
                        icon: Icons.alt_route,
                        title: 'Personalized Itineraries',
                        description:
                            'Get custom travel plans tailored to your preferences, budget, and schedule',
                      ),
                      _buildFeatureCard(
                        icon: Icons.cloud,
                        title: 'Weather Insights',
                        description:
                            'Make informed decisions with real-time weather forecasts for your destinations',
                      ),
                      _buildFeatureCard(
                        icon: Icons.account_balance_wallet,
                        title: 'Budget Tracking',
                        description:
                            'Easily monitor your expenses and stay within your travel budget',
                      ),
                      _buildFeatureCard(
                        icon: Icons.map,
                        title: 'Local Discoveries',
                        description:
                            'Explore hidden gems and authentic local experiences at your destination',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildFeatureCard({
  required IconData icon,
  required String title,
  required String description,
}) {
  return Container(
    width: 250,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Color(0xFF2C2C33),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      children: [
        Icon(icon, size: 40, color: Colors.blueAccent),
        SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
}