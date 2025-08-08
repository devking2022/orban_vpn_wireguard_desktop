import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showAlertDialog(
    {required BuildContext context,
    String? title,
    String? des,
    Function()? onTap}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title!),
          content: Text(des!),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            CupertinoDialogAction(
                textStyle: TextStyle(color: Colors.red),
                isDefaultAction: true,
                onPressed: onTap,
                child: Text("Confirm")),
          ],
        );
      });
}
