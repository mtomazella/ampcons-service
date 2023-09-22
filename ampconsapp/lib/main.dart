import 'package:ampconsapp/pages/config/config.dart';
import 'package:ampconsapp/providers/config_notifier.dart';
import 'package:ampconsapp/providers/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:ampconsapp/pages/home/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class AmpconsApp extends StatelessWidget {
  const AmpconsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ConfigProvider.getProvider(),
    ], child: const App());
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMPCONS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.yellow, brightness: Brightness.light),
        // brightness: Brightness.light),
        useMaterial3: true,
      ),
      routes: <String, WidgetBuilder>{
        '/config': (BuildContext context) => const ConfigPage(),
      },
      home: const HomePage(),
    );
  }
}
