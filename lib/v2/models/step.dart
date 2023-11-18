class StepModel {
  String type;

  String time;
  String distance;

  String line;
  String fromStation;
  String toStation;

  String headsign;

  int numStops;

  StepModel(
      {required this.type,
      required this.time,
      required this.distance,
      required this.line,
      required this.fromStation,
      required this.toStation,
      required this.headsign,
      required this.numStops});
}
