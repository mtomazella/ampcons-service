class Measurement {
  late double tension;
  late double current;
  late double power;

  Measurement({required double tension, required double current});

  Measurement.withPower(
      {required double tension,
      required double current,
      required double power});
}
