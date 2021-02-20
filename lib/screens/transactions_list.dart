import 'package:flutter/material.dart';

import '../components/centered_message.dart';
import '../components/progress.dart';
import '../http/web_clients/transaction_web_client.dart';
import '../models/transaction.dart';

class TransactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TransactionWebClient _webClient = TransactionWebClient();

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions Feed'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: _webClient.findAll(),
        initialData: [],
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Progress(
                label: 'Loading',
              );
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Transaction> transactions = snapshot.data;

              if (snapshot.hasData && transactions.isNotEmpty) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final Transaction transaction = transactions[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.monetization_on),
                        title: Text(
                          transaction.value.toString(),
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${transaction.contact.name} - Account: ${transaction.contact.accountNumber.toString()}',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: transactions.length,
                );
              }

              return CenteredMessage(
                message: 'No Transactions Found.',
                icon: Icons.warning,
              );
          }
          return CenteredMessage(
            message: 'Unknown error.',
            icon: Icons.warning,
          );
        },
      ),
    );
  }
}
