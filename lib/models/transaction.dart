import 'package:flutter/foundation.dart';

import 'contact.dart';

class Transaction {
  final double value;
  final Contact contact;

  Transaction({
    @required this.value,
    @required this.contact,
  })  : assert(value != null),
        assert(contact != null);

  @override
  String toString() {
    return 'Transaction{value: $value, contact: $contact}';
  }

  Transaction.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        contact = Contact.fromJson(json['contact']);

  Map<String, dynamic> toJson() => {
        'value': value,
        'contact': contact.toJson(),
      };
}
