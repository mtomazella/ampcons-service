import 'package:ampconsapp/components/loading_page.dart';
import 'package:ampconsapp/pages/config/config.dart';
import 'package:ampconsapp/pages/error/error.dart';
import 'package:ampconsapp/pages/sensor/sensor.dart';
import 'package:ampconsapp/providers/config_notifier.dart';
import 'package:ampconsapp/providers/config_provider.dart';
import 'package:ampconsapp/providers/measurements_notifier.dart';
import 'package:ampconsapp/providers/measurements_provider.dart';
import 'package:ampconsapp/providers/user_notifier.dart';
import 'package:ampconsapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:ampconsapp/pages/home/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AmpconsApp());
}

class AmpconsApp extends StatelessWidget {
  const AmpconsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ConfigProvider.getProvider(),
      UserProvider.getProvider(),
      MeasurementsProvider.getProvider(),
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
            seedColor: Colors.yellow,
            brightness: (Provider.of<ConfigNotifier>(context).darkTheme)
                ? Brightness.dark
                : Brightness.light),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: <String, WidgetBuilder>{
        '/config': (BuildContext context) => Consumer<UserNotifier>(
            builder: (context, userNotifier, _) => FutureBuilder(
                  future: Provider.of<UserNotifier>(context, listen: false)
                      .fetchUser(),
                  builder: (context, snapshot) {
                    try {
                      return Consumer<ConfigNotifier>(
                          builder: (context, configNotifier, _) =>
                              ConfigPage(configNotifier: configNotifier));
                    } catch (e) {
                      return const LoadingPage();
                    }
                  },
                )),
        '/error': (context) {
          var modalRoute = ModalRoute.of(context);
          var params = modalRoute == null
              ? ErrorPageRouteParams()
              : modalRoute.settings.arguments as ErrorPageRouteParams;
          return ErrorPage(
            title: params.title,
            description: params.description,
          );
        },
        '/home': (context) {
          return Consumer<UserNotifier>(
            builder: (context, userNotifier, _) => FutureBuilder(
              future:
                  Provider.of<UserNotifier>(context, listen: false).fetchUser(),
              builder: (context, snapshot) {
                try {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingPage();
                  }
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasError) {
                    Navigator.pushNamed(context, '/error',
                        arguments: ErrorPageRouteParams(
                            title: "Usuário Não Encontrado",
                            description: [
                              "Não foi possível buscar o usuário",
                              "Cheque sua conexão à internet"
                            ]));
                  }
                  return Consumer<MeasurementsNotifier>(
                      builder: (context, measurementsNotifier, _) => HomePage(
                            user: userNotifier.user,
                            measurementsNotifier: measurementsNotifier,
                          ));
                } catch (e) {
                  print(e);
                  Navigator.pushNamed(context, '/error');
                  return const LoadingPage();
                }
              },
            ),
          );
        },
        '/sensor': (context) {
          var modalRoute = ModalRoute.of(context);

          if (modalRoute == null || modalRoute.settings.arguments == null) {
            Navigator.pushNamed(context, '/error',
                arguments: ErrorPageRouteParams(
                    title: 'Sensor Inválido', description: []));
          }

          var params = modalRoute?.settings.arguments as SensorPageRouteParams;
          // var params = SensorPageRouteParams(id: '0');

          return Consumer<UserNotifier>(
            builder: (context, userNotifier, _) => FutureBuilder(
              future:
                  Provider.of<UserNotifier>(context, listen: false).fetchUser(),
              builder: (context, snapshot) {
                try {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingPage();
                  }
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasError) {
                    Navigator.pushNamed(context, '/error',
                        arguments: ErrorPageRouteParams(
                            title: "Usuário Não Encontrado",
                            description: [
                              "Não foi possível buscar o usuário",
                              "Cheque sua conexão à internet"
                            ]));
                  }
                  return Consumer<MeasurementsNotifier>(
                      builder: (context, measurementsNotifier, _) => SensorPage(
                            id: params.id,
                            user: userNotifier.user,
                            measurementsNotifier: measurementsNotifier,
                          ));
                } catch (e) {
                  print(e);
                  Navigator.pushNamed(context, '/error');
                  return const LoadingPage();
                }
              },
            ),
          );
        }
      },
    );
  }
}
