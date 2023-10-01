import 'package:ampconsapp/models/user.dart';
import 'package:flutter/material.dart';

class UserDisplay extends StatelessWidget {
  final User user;

  const UserDisplay({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
            backgroundImage: AssetImage('assets/user.png'),
            radius: 40,
            backgroundColor: Colors.white),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Olá, ${user.name}',
              style: const TextStyle(fontSize: 25),
            ),
            Text('@${user.id}'),
          ]),
        ),
      ],
    );
  }
}
