import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:ampconsapp/models/user.dart';

class HttpService {
  static String baseUrl = 'http://192.168.15.8:3001';

  static Future<User> getUser(String userId) async {
    var userResponse = await http.get(Uri.parse('$baseUrl/user/$userId'));

    print(userResponse);

    if (userResponse.statusCode == 204) throw 'User not found';

    var json = jsonDecode(userResponse.body);
    print(json);
    return User(id: json['id'], name: json['name']
        // , sensorIds: json['sensorIds']
        );
  }
}
