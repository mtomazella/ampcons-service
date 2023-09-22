import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[SfCartesianChart()],
        ),
      ),
    );
  }
}
