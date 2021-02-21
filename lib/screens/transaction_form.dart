import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../components/progress.dart';
import '../components/response_dialog.dart';
import '../components/transaction_auth_dialog.dart';
import '../http/web_clients/transaction_web_client.dart';
import '../models/contact.dart';
import '../models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String _transactionId = Uuid().v4();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: isLoading,
                child: Progress(
                  label: 'Sending...',
                ),
              ),
              Text(
                widget.contact.name,
                style: TextStyle(fontSize: 24.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  enabled: !isLoading,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: isLoading
                        ? null
                        : () {
                            final double value = double.tryParse(_valueController.text);
                            final transactionCreated = Transaction(
                              id: _transactionId,
                              value: value,
                              contact: widget.contact,
                            );
                            showDialog(
                              context: context,
                              builder: (contextDialog) => TransactionAuthDialog(
                                onConfirm: (String password) {
                                  _save(transactionCreated, password, context);
                                },
                              ),
                            );
                          },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save(Transaction transactionCreated, String password, BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final Transaction transaction = await _send(transactionCreated, password, context);
    await _showSuccessTransaction(transaction, context);
  }

  Future _showSuccessTransaction(Transaction transaction, BuildContext context) async {
    isLoading = false;
    if (transaction != null) {
      await showDialog(
        context: context,
        builder: (contextDialog) => SuccessDialog('Successful transaction.'),
      );
      Navigator.pop(context);
    }
  }

  Future<Transaction> _send(Transaction transactionCreated, String password, BuildContext context) async {
    return await _webClient
        .save(transactionCreated, password)
        .catchError(
          (error) => _showFailureMessage(context, message: 'A timeout was detected. Try again latter.'),
          test: (e) => e is TimeoutException,
        )
        .catchError(
          (error) => _showFailureMessage(context, message: error.message),
          test: (e) => e is HttpException,
        )
        .catchError(
          (error) => _showFailureMessage(context),
        )
        .whenComplete(
          () => setState(() {
            isLoading = false;
          }),
        );
  }

  void _showFailureMessage(BuildContext context, {String message = 'Unknown error.'}) {
    showDialog(
      context: context,
      builder: (contextDialog) => FailureDialog(message),
    );
  }
}
