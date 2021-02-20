import 'package:flutter/material.dart';

import 'contacts_list.dart';
import 'transactions_list.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/imgs/logo.png'),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FeatureItem(
                    name: 'Transfers',
                    icon: Icons.monetization_on,
                    onTap: () => _showContactsList(context),
                  ),
                  _FeatureItem(
                    name: 'Transactions Feed',
                    icon: Icons.description,
                    onTap: () => _showTransactionsFeed(context),
                  ),
                  _FeatureItem(
                    name: 'Contact Us',
                    icon: Icons.chat,
                    onTap: () => _showContactUs(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactsList(BuildContext context) {
    final route = MaterialPageRoute(builder: (context) => ContactsList());
    Navigator.of(context).push(route);
  }

  void _showTransactionsFeed(BuildContext context) {
    final route = MaterialPageRoute(builder: (context) => TransactionsList());
    Navigator.of(context).push(route);
  }

  void _showContactUs(BuildContext context) {
    print('"Contact Us" was tapped.');
  }
}

class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureItem({
    Key key,
    @required this.name,
    @required this.icon,
    @required this.onTap,
  })  : assert(name != null),
        assert(icon != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          child: Tooltip(
            message: name,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: 100.0,
              width: 180.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 36.0,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
