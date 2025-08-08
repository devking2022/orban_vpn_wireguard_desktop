import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WatchAdDialog extends StatelessWidget {
  final VoidCallback onComplete;

  const WatchAdDialog({Key? key, required this.onComplete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Change Theme'),
      content: const Text('Watch an Ad to Change App Theme.'),
      actions: [
        CupertinoDialogAction(
            isDefaultAction: true,
            textStyle: const TextStyle(color: Colors.green),
            child: const Text('Watch Ad'),
            onPressed: () {
              Get.back();
              onComplete();
            }),
      ],
    );
  }
}
