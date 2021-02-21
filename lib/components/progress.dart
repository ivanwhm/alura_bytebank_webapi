import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  final String label;

  const Progress({
    Key key,
    @required this.label,
  })  : assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              label,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
