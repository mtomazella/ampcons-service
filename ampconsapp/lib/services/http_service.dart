import 'dart:convert';

import 'package:ampconsapp/models/measurement.dart';
import 'package:ampconsapp/models/measurement_summary.dart';
import 'package:ampconsapp/models/sensor.dart';
import 'package:http/http.dart' as http;

import 'package:ampconsapp/models/user.dart';

class HttpService {
  // static String baseUrl = 'http://192.168.15.8:3001';
  // static String baseUrl = 'http://172.26.97.101:3001';
  static String baseUrl = 'http://172.28.240.101:3001';

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

    if (summaryResponse.statusCode == 204) {
      return MeasurementSummary(
          power: double.negativeInfinity, current: double.negativeInfinity);
    }

    if (summaryResponse.statusCode != 200) throw "Unknown";

    double convertDouble(dynamic value) {
      if (value == null) return double.negativeInfinity;
      if (value is String) return double.parse(value);
      if (value is int) return value.toDouble();
      return value;
    }

    var json = jsonDecode(summaryResponse.body);
    return MeasurementSummary(
        power: convertDouble(json['power']),
        current: convertDouble(json['current']));
  }

  static Future<List<Measurement>> getMeasurements(
      {required String userId}) async {
    var summaryResponse =
        await http.get(Uri.parse('$baseUrl/measurements/$userId'));

    if (summaryResponse.statusCode == 204) {
      return Future.value([]);
    }

    if (summaryResponse.statusCode != 200) Future.error('Unknown');

    double convertDouble(dynamic value) {
      if (value == null) return double.negativeInfinity;
      if (value is String) return double.parse(value);
      if (value is int) return value.toDouble();
      return value;
    }

    String convertTime(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    Map<String, dynamic> json = jsonDecode(summaryResponse.body);
    return List.from((json['data'] as List<dynamic>).map((e) =>
        Measurement.withPower(
            time: convertTime(e['time']),
            tension: convertDouble(e['tension']),
            current: convertDouble(e['current']),
            power: convertDouble(e['power']))));
  }

  static Future<List<Sensor>> getUserSensors({required String userId}) async {
    var response = await http.get(Uri.parse('$baseUrl/sensor/user/$userId'));

    if (response.statusCode == 204) {
      return Future.value([]);
    }

    if (response.statusCode != 200) Future.error('Unknown');

    Map<String, dynamic> json = jsonDecode(response.body);
    return List.from((json['data'] as List<dynamic>).map((e) {
      return Sensor(id: e['id'], name: e['name']);
    }));
  }
}
