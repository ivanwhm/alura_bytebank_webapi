import 'dart:convert';

import 'package:http/http.dart';

import '../../models/transaction.dart';
import '../web_client.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(
      baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(Duration(seconds: 5));

    return jsonDecode(response.body).map((e) => Transaction.fromJson(e)).toList();
  }

  Future<Transaction> save(Transaction transaction) async {
    final Response response = await client
        .post(
          baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'password': '1000',
          },
          body: jsonEncode(transaction.toJson()),
        )
        .timeout(Duration(seconds: 5));

    return Transaction.fromJson(jsonDecode(response.body));
  }
}
