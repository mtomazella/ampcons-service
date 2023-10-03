import 'package:ampconsapp/models/measurement_summary.dart';
import 'package:ampconsapp/services/http_service.dart';
import 'package:flutter/foundation.dart';

class MeasurementsNotifier extends ChangeNotifier {
  MeasurementSummary? summary;

  Future<MeasurementSummary> updateSummary() async {
    try {
      MeasurementSummary newSummary =
          await HttpService.getSummary(userId: 'thisismia');
      summary = newSummary;
      notifyListeners();
      return Future.value(summary);
    } catch (error) {
      return Future.error(error);
    }
  }
}
