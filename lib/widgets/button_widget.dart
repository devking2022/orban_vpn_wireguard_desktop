import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/constants.dart';

Widget button({
  required String lable,
  required Function() onTap,
  Color? buttonColor,
  Color? borderColor,
  Color? textColor,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: Get.height * 0.065,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: buttonColor ?? primery,
          border: Border.all(color: borderColor ?? primery),
          borderRadius: BorderRadius.circular(12)),
      alignment: Alignment.center,
      child: Text(
        lable,
        style: TextStyle(
            color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
  );
}

Widget iconButton({
  required String lable,
  required Function() onTap,
  required String icon,
  Color? buttonColor,
  Color? textColor,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: Get.height * 0.065,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: buttonColor ?? primery,
          borderRadius: BorderRadius.circular(12)),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(icon),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            lable,
            style: TextStyle(
                color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}
