import 'package:flutter/material.dart';

class ErrorPageRouteParams {
  late String? title;
  late List<String>? description;

  ErrorPageRouteParams({this.title, this.description});
}

// ignore: must_be_immutable
class ErrorPage extends StatelessWidget {
  late String title;
  late List<String> description;

  ErrorPage({super.key, String? title, List<String>? description}) {
    this.title = title ?? "Erro Desconhecido";
    this.description = description ??
        ["Um erro desconhecido aconteceu", "Tente novamente mais tarde"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              size: 120,
              color: Theme.of(context).colorScheme.error,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Theme.of(context).shadowColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            Container(
              height: 10,
            ),
            ...description.map((text) => Text(
                  text,
                  style: const TextStyle(fontSize: 20),
                )),
            Container(
              height: 150,
            )
          ],
        ),
      ),
    );
  }
}
