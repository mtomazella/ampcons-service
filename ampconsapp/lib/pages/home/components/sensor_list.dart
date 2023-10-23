import 'package:ampconsapp/models/sensor.dart';
import 'package:ampconsapp/models/user.dart';
import 'package:ampconsapp/services/http_service.dart';
import 'package:flutter/material.dart';

class SensorList extends StatefulWidget {
  final User user;

  const SensorList({super.key, required this.user});

  @override
  State<SensorList> createState() => _SensorListState();
}

class _SensorListState extends State<SensorList> {
  Future<bool>? initialized;
  List<Sensor> sensors = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    var response = await HttpService.getUserSensors(userId: widget.user.id);

    setState(() {
      sensors = response;
    });

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialized,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text("Não foi possivel carregar a lista de sensores");
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15, top: 20),
                child: Text(
                  "Sensores",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              ...sensors
                  .map(
                    (e) => ListTile(
                      onTap: () {},
                      title: Text(e.name, style: const TextStyle(fontSize: 20)),
                      leading: Icon(
                        IconData(e.icon ?? Icons.sensors.codePoint,
                            fontFamily: 'MaterialIcons'),
                        size: 35,
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        size: 35,
                      ),
                    ),
                  )
                  .toList()
            ],
          );
        });
  }
}
