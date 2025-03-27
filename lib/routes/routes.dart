import 'package:flutter/material.dart';
import 'package:my_first_app/screens/LoginScreen.dart';
import 'package:my_first_app/screens/CardsScreen.dart';
import 'package:my_first_app/main.dart'; // Import MyHomePage

class Routes {
  static const String LOGINSCREEN = '/login';
  static const String CARDSSCREEN = '/cards';

  // Routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
    '/': (context) => MyHomePage(title: 'Home Page'), // Set MyHomePage as the initial route
    LOGINSCREEN: (context) => LoginScreen(),
    CARDSSCREEN: (context) => CardsScreen(),
  };
}