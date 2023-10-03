import 'dart:convert';

import 'package:ampconsapp/models/measurement_summary.dart';
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

  static Future<MeasurementSummary> getSummary({required String userId}) async {
    var summaryResponse =
        await http.get(Uri.parse('$baseUrl/measurements/$userId/summary'));

    if (summaryResponse.statusCode != 200) throw "Unknown";

    double convertDouble(dynamic value) {
      if (value is String) return double.parse(value);
      if (value is int) return value.toDouble();
      return value;
    }

    var json = jsonDecode(summaryResponse.body);
    return MeasurementSummary(
        tension: convertDouble(json['tension']),
        current: convertDouble(json['current']));
  }
}
