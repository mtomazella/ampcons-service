import 'dart:async';

import 'package:ampconsapp/components/stateful_wrapper.dart';
import 'package:ampconsapp/models/user.dart';
import 'package:ampconsapp/pages/home/components/summary_item.dart';
import 'package:ampconsapp/providers/measurements_notifier.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
          measurementsTimer =
              Timer.periodic(const Duration(seconds: 5), (timer) {
            measurementsNotifier.updateSummary();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SfCartesianChart(),
                SummaryItem(
                    icon: Icons.bolt,
                    color: Colors.indigo,
                    label: "Corrente",
                    value: measurementsNotifier.summary?.current
                        .toStringAsFixed(2),
                    unit: "A"),
                SummaryItem(
                  icon: Icons.electrical_services,
                  color: Colors.deepPurple,
                  label: "Potência",
                  value: measurementsNotifier.summary?.power.toStringAsFixed(2),
                  unit: "W",
                ),
              ],
            ),
          ),
        ));
  }
}
