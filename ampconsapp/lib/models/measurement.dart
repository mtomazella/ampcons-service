class Measurement {
  late String time;
  late double tension;
  late double current;
  late double power;

  Measurement(
      {required this.time, required this.tension, required this.current});

  Measurement.withPower(
      {required this.time,
      required this.tension,
      required this.current,
      required this.power});
}
