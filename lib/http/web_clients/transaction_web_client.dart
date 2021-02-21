import 'dart:convert';

import 'package:http/http.dart';

import '../../models/transaction.dart';
import '../web_client.dart';

class TransactionWebClient {
  static final Map<int, String> _httpErrors = {
    400: 'There was an error while submitting the transaction.',
    401: 'Authentication failed.',
    409: 'Transaction already exists.',
    500: 'Internal server error.',
  };

  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(
      baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return jsonDecode(response.body).map<Transaction>((e) => Transaction.fromJson(e)).toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final Response response = await client.post(
      baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'password': password,
      },
      body: jsonEncode(transaction.toJson()),
    );

    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    throw HttpException(_getMessage(response.statusCode));
  }

  String _getMessage(int statusCode) {
    if (_httpErrors.containsKey(statusCode)) {
      return _httpErrors[statusCode];
    }

    return 'Unknown error.';
  }
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}
