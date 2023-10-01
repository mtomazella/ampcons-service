import 'package:ampconsapp/components/loading_page.dart';
import 'package:ampconsapp/pages/config/config.dart';
import 'package:ampconsapp/providers/config_notifier.dart';
import 'package:ampconsapp/providers/config_provider.dart';
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
        '/notFound': (context) {
          return const Text('User not found');
        }
      },
      home: Consumer<UserNotifier>(
        builder: (context, userNotifier, _) => FutureBuilder(
          future: Provider.of<UserNotifier>(context, listen: false).fetchUser(),
          builder: (context, snapshot) {
            try {
              return HomePage(
                user: userNotifier.user,
              );
            } catch (e) {
              return const LoadingPage();
            }
          },
        ),
      ),
    );
  }
}
