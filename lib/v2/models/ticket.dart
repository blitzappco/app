import '../utils/utils.dart';

List<String> convertLines(List<dynamic> dynamicList) {
  return dynamicList.map((item) => item.toString()).toList();
}

class Ticket {
  String? id;
  String? accountID;
  String? name;
  String? city;
  DateTime? expiresAt;
  DateTime? createdAt;
  double? price;

  Ticket({
    this.id,
    this.accountID,
    this.name,
    this.city,
    this.expiresAt,
    this.createdAt,
    this.price,
  });

  factory Ticket.fromJSON(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      accountID: json['accountID'],
      name: capitalize(json['name'].toString()),
      city: json['city'],
      price: json['price'].toDouble() ?? 0.0,
      expiresAt: DateTime.parse(json['expiresAt']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
