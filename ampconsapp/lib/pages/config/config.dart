import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tema escuro", textScaleFactor: 1.5),
                    Switch(value: true, onChanged: (bool state) => {})
                  ],
                )
              ],
            ),
          )),
    );
  }
}
