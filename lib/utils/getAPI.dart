import 'package:http/http.dart' as http;
import 'dart:convert';

class CardsData {
  static Future<String> getJson(String url, String outgoing) async {
    String ret = "";

    try {
      http.Response response = await http.post(
        Uri.parse(url), // Convert the String URL to a Uri
        body: utf8.encode(outgoing),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        encoding: Encoding.getByName("utf-8"),
      );
      ret = response.body;
    } catch (e) {
      print(e.toString());
    }

    return ret;
  }
}

class GlobalData {
  static int userId = -1; // Initialize with a default value
  static String firstName = '';
  static String lastName = '';
  static String loginName = '';
  static String password = '';
}