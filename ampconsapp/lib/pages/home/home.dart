import 'dart:async';

import 'package:ampconsapp/components/sensor_information.dart';
import 'package:ampconsapp/models/sensor.dart';
import 'package:ampconsapp/models/user.dart';
import 'package:ampconsapp/pages/home/components/sensor_list.dart';
import 'package:ampconsapp/pages/sensor/sensor.dart';
import 'package:ampconsapp/providers/measurements_notifier.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User user;
  final MeasurementsNotifier measurementsNotifier;

  const HomePage(
      {super.key, required this.user, required this.measurementsNotifier});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? measurementsTimer;

  void requestMeasurementsUpdate() {
    widget.measurementsNotifier.updateSummary();
    widget.measurementsNotifier.updateMeasurementList();
  }

  void initMeasurements() async {
    widget.measurementsNotifier.selectSensors([]);
    requestMeasurementsUpdate();
  }

  @override
  void initState() {
    super.initState();

    measurementsTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      requestMeasurementsUpdate();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => initMeasurements());
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
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/config'),
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.inverseSurface,
              ))
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            SensorInformation(
              measurementsNotifier: widget.measurementsNotifier,
            ),
            SensorList(
                user: widget.user,
                onTapSensor: (BuildContext context, Sensor sensor) {
                  Navigator.pushNamed(context, '/sensor',
                          arguments: SensorPageRouteParams(id: sensor.id))
                      .then((value) => initMeasurements());
                })
          ],
        ),
      ),
    );
  }
}
