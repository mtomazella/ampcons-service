import 'dart:async';

import 'package:ampconsapp/components/sensor_information.dart';
import 'package:ampconsapp/models/sensor.dart';
import 'package:ampconsapp/models/user.dart';
import 'package:ampconsapp/providers/measurements_notifier.dart';
import 'package:ampconsapp/services/http_service.dart';
import 'package:flutter/material.dart';

class SensorPageRouteParams {
  late String id;

  SensorPageRouteParams({required this.id});
}

class SensorPage extends StatefulWidget {
  final String id;
  final User user;
  final MeasurementsNotifier measurementsNotifier;

  const SensorPage(
      {super.key,
      required this.id,
      required this.user,
      required this.measurementsNotifier});

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  Sensor? sensor;
  Timer? measurementsTimer;

  void requestMeasurementsUpdate() {
    widget.measurementsNotifier.updateSummary();
    widget.measurementsNotifier.updateMeasurementList();
  }

  void loadSensorData() async {
    widget.measurementsNotifier.selectSensors([widget.id]);

    Sensor sensorResult = await HttpService.getSensor(sensorId: widget.id);
    setState(() {
      sensor = sensorResult;
    });

    requestMeasurementsUpdate();
  }

  @override
  void initState() {
    super.initState();

    measurementsTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      requestMeasurementsUpdate();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => loadSensorData());
  }

  @override
  void deactivate() {
    super.deactivate();

    measurementsTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: sensor != null
            ? Text(sensor!.name)
            : const CircularProgressIndicator(),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            SensorInformation(
                measurementsNotifier: widget.measurementsNotifier),
          ],
        ),
      ),
    );
  }
}
