import 'package:ampconsapp/components/loading_page.dart';
import 'package:ampconsapp/models/user.dart';
import 'package:ampconsapp/pages/config/components/user_display.dart';
import 'package:ampconsapp/providers/config_notifier.dart';
import 'package:ampconsapp/providers/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigPage extends StatelessWidget {
  final ConfigNotifier configNotifier;

  const ConfigPage({super.key, required this.configNotifier});

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserNotifier>(context).user;

    if (user == null) return const LoadingPage();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Configurações'),
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UserDisplay(user: user),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tema escuro", textScaleFactor: 1.5),
                    Switch(
                        trackColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return Theme.of(context).colorScheme.primary;
                          }
                          return Theme.of(context).colorScheme.background;
                        }),
                        value: configNotifier.darkTheme,
                        onChanged: (bool state) {
                          configNotifier.darkTheme = state;
                        })
                  ],
                )
              ],
            ),
          )),
    );
  }
}
