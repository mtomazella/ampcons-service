import 'dart:async';

import 'package:ampconsapp/components/sensor_information.dart';
import 'package:ampconsapp/components/stateful_wrapper.dart';
import 'package:ampconsapp/models/user.dart';
import 'package:ampconsapp/pages/home/components/sensor_list.dart';
import 'package:ampconsapp/providers/measurements_notifier.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final User user;
  final MeasurementsNotifier measurementsNotifier;

  Timer? measurementsTimer;

  HomePage({super.key, required this.user, required this.measurementsNotifier});

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: () {
          measurementsNotifier.selectSensors(null);

          measurementsTimer =
              Timer.periodic(const Duration(seconds: 5), (timer) {
            measurementsNotifier.updateSummary();
            measurementsNotifier.updateMeasurementList();
          });
        },
        onDeactivate: () {
          measurementsTimer?.cancel();
        },
        child: Scaffold(
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
                SensorInformation(measurementsNotifier: measurementsNotifier),
                SensorList(
                  user: user,
                )
              ],
            ),
          ),
        ));
  }
}
