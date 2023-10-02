import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:ampconsapp/models/user.dart';

class HttpService {
  // static String baseUrl = 'http://192.168.15.8:3001';
  static String baseUrl = 'http://172.26.97.101:3001';

  static Future<User> getUser(String userId) async {
    var userResponse = await http.get(Uri.parse('$baseUrl/user/$userId'));

    if (userResponse.statusCode == 204) throw "NotFound";
    if (userResponse.statusCode != 200) throw "Unknown";

    var json = jsonDecode(userResponse.body);
    return User(id: json['id'], name: json['name']
        // , sensorIds: json['sensorIds']
        );
  }
}
