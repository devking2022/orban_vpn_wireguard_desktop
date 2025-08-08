import 'package:flutter/material.dart';

Widget side_menu(
    {required String title,
    required Function() onTap,
    required IconData icon}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    child: ListTile(
      leading: Icon(icon),
      horizontalTitleGap: 0,
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      onTap: onTap,
    ),
  );
}
