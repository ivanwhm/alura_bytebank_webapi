import 'package:flutter/material.dart';

import 'screens/dashboard.dart';

void main() => runApp(ByteBankApp());

class ByteBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green[900],
      ),
      home: Dashboard(),
    );
  }
}
