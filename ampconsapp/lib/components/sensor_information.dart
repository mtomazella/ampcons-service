import 'package:ampconsapp/components/summary_item.dart';
import 'package:ampconsapp/models/measurement.dart';
import 'package:ampconsapp/providers/measurements_notifier.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class SensorInformation extends StatelessWidget {
  final MeasurementsNotifier measurementsNotifier;

  const SensorInformation({super.key, required this.measurementsNotifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SfCartesianChart(primaryXAxis: CategoryAxis(), series: [
          LineSeries(
              dataSource: measurementsNotifier.measurementList,
              xValueMapper: (Measurement measurement, _) => measurement.time,
              yValueMapper: (Measurement measurement, _) => measurement.power),
        ]),
        SummaryItem(
            icon: Icons.bolt,
            color: Colors.indigo,
            label: "Corrente",
            value: measurementsNotifier.summary?.current.toStringAsFixed(2),
            unit: "A"),
        SummaryItem(
          icon: Icons.electrical_services,
          color: Colors.deepPurple,
          label: "Potência",
          value: measurementsNotifier.summary?.power.toStringAsFixed(2),
          unit: "W",
        ),
      ],
    );
  }
}
