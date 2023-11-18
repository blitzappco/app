class Account {
  String? id;
  String? phone;
  String? firstName;
  String? lastName;
  String? stripeCustomerID;

  Account({
    this.id,
    this.phone,
    this.firstName,
    this.lastName,
    this.stripeCustomerID,
  });

  factory Account.fromJSON(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      phone: json['phone'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      stripeCustomerID: json['stripeCustomerID'],
    );
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> accountJSON = <String, dynamic>{
      'id': id,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'stripeCustomerID': stripeCustomerID,
    };

    return accountJSON;
  }
}
