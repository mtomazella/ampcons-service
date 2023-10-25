import 'package:ampconsapp/models/measurement.dart';
import 'package:ampconsapp/models/measurement_summary.dart';
import 'package:ampconsapp/services/http_service.dart';
import 'package:flutter/foundation.dart';

class MeasurementsNotifier extends ChangeNotifier {
  List<String>? selectedSensors;

  MeasurementSummary? summary;
  List<Measurement> measurementList = [];

  void selectSensors(List<String>? sensorList) {
    summary = null;
    measurementList = [];
    selectedSensors = sensorList;
    notifyListeners();
  }

  Future<MeasurementSummary> updateSummary() async {
    try {
      MeasurementSummary newSummary = await HttpService.getSummary(
          userId: 'thisismia', sensorIds: selectedSensors);
      summary = newSummary;
      notifyListeners();
      return Future.value(summary);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<List<Measurement>> updateMeasurementList() async {
    try {
      List<Measurement> newList = await HttpService.getMeasurements(
          userId: 'thisismia', sensorIds: selectedSensors);
      measurementList = newList;
      notifyListeners();
      return Future.value(measurementList);
    } catch (error) {
      return Future.error(error);
    }
  }
}
