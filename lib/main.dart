import 'package:flutter/material.dart';
import 'package:my_first_app/routes/routes.dart';
import 'package:my_first_app/utils/getAPI.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      routes: Routes.getroutes,
    );
  }
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
@override
Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16.0), // Add some padding around the buttons
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center the buttons vertically
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[50], // Background color
            foregroundColor: Colors.black,    // Text color
            padding: EdgeInsets.all(8.0),     // Button padding
          ),
          child: Text(
            'Go to Cards',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/cards'); // Navigate to the Cards screen
          },
        ),
        SizedBox(height: 16.0), // Add spacing between the buttons
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[50], // Background color
            foregroundColor: Colors.black,    // Text color
            padding: EdgeInsets.all(8.0),     // Button padding
          ),
          child: Text(
            'Go to Login',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/login'); // Navigate to the Login screen
          },
        ),
      ],
    ),
  );
}

  


}