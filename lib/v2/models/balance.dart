class Balance {
  String? id;
  double? value;

  Balance({
    this.id,
    this.value,
  });

  factory Balance.fromJSON(Map<String, dynamic> json) {
    return Balance(id: json['id'], value: json['value'].toDouble());
  }
}
