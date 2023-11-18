class Trip {
  String accountID;
  String name;
  String address;
  String type;
  double longitude;
  double latitude;

  DateTime datetime;

  Trip({
    required this.accountID,
    required this.name,
    required this.address,
    required this.type,
    required this.longitude,
    required this.latitude,
    required this.datetime,
  });

  factory Trip.fromJSON(Map<String, dynamic> json) {
    return Trip(
        accountID: json['accountID'],
        name: json['name'],
        address: json['address'],
        type: json['type'],
        longitude: json['longitude'].toDouble(),
        latitude: json['latitude'].toDouble(),
        datetime: DateTime.parse(json['datetime']));
  }

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'address': address,
      'type': type,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}
