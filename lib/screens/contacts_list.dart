import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/centered_message.dart';
import '../components/progress.dart';
import '../database/dao/contact_dao.dart';
import '../models/contact.dart';
import '../screens/transaction_form.dart';
import 'contact_form.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfers'),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 32.0,
            ),
            tooltip: 'Add Contact',
            onPressed: () => _addContact(context),
          )
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Contact>>(
          future: _dao.findAll(),
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
                final List<Contact> contacts = snapshot.data;

                if (contacts.isNotEmpty) {
                  return ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return _ContactItem(
                        contact: contact,
                        onTap: () => _addTransaction(context, contact),
                      );
                    },
                  );
                }

                return CenteredMessage(
                  message: 'No Contacts Found.',
                  icon: Icons.warning,
                );
            }

            return CenteredMessage(
              message: 'Unknown error.',
              icon: Icons.warning,
            );
          },
        ),
      ),
    );
  }

  void _addContact(BuildContext context) {
    final route = MaterialPageRoute(builder: (context) => ContactForm());
    Navigator.of(context).push(route).then((value) => setState(() {}));
  }

  void _addTransaction(BuildContext context, Contact contact) {
    final route = MaterialPageRoute(builder: (context) => TransactionForm(contact));
    Navigator.of(context).push(route).then((value) => setState(() {}));
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;

  _ContactItem({
    Key key,
    @required this.contact,
    @required this.onTap,
  })  : assert(contact != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          contact.name,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        subtitle: Text(
          'Account number: ${contact.accountNumber.toString()}',
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
