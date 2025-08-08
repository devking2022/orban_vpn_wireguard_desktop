import 'package:flutter/material.dart';

import '../helpers/constants.dart';

class HorizontalOrLine extends StatelessWidget {
  const HorizontalOrLine({
    required this.label,
    required this.auth,
  });

  final String label;
  final bool auth;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: Divider(
              color: auth == true ? textSecondry : Color(0xff797C7B),
            )),
      ),
      Text(
        label,
        style: TextStyle(
            color: auth == true ? textSecondry : Color(0xff797C7B),
            fontSize: 16),
      ),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: auth == true ? textSecondry : Color(0xff797C7B),
            )),
      ),
    ]);
  }
}
