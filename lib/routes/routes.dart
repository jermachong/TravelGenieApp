import 'package:flutter/material.dart';
import 'package:my_first_app/screens/LoginScreen.dart';
import 'package:my_first_app/screens/CardsScreen.dart';
import 'package:my_first_app/screens/landing.dart';
import 'package:my_first_app/screens/planTrip.dart'; 
import 'package:my_first_app/screens/savedTrips.dart';
//import 'package:my_first_app/main.dart'; // Import MyHomePage

class Routes {
  static const String LOGINSCREEN = '/login';
  static const String CARDSSCREEN = '/cards';
  static const String LANDINGSCREEN = '/landing';
  static const String PLANTRIPSCREEN = '/plan-trip'; 
  static const String SAVEDTRIPSSCREEN = '/saved-trips';

  // Routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
    '/': (context) => LandingPage(), // Set landing page as the initial route 
    LOGINSCREEN: (context) => LoginScreen(), 
    CARDSSCREEN: (context) => CardsScreen(),
    LANDINGSCREEN: (context) => LandingPage(),
    PLANTRIPSCREEN: (context) => PlanTripPage(), 
    SAVEDTRIPSSCREEN: (context) => SavedTripsPage(),
  };
}