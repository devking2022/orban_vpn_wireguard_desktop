import 'package:flutter/material.dart';

import '../helpers/constants.dart';
import '../models/network_data.dart';

class NetworkCard extends StatelessWidget {
  final NetworkData data;

  const NetworkCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: secondry),
            borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          minLeadingWidth: 20,
          //flag
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: secondry, borderRadius: BorderRadius.circular(12)),
            child: Icon(data.icon.icon,
                color: data.icon.color, size: data.icon.size ?? 28),
          ),

          //title
          title: Text(data.title),

          //subtitle
          subtitle: Text(data.subtitle),
        ));
  }
}
