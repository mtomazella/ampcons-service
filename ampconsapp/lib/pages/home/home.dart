import 'package:ampconsapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[SfCartesianChart()],
        ),
      ),
    );
  }
}
