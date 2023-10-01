class User {
  late String id;
  late String name;
  late List<String>? sensorIds;

  User({required this.id, required this.name, this.sensorIds});
}
