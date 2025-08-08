import 'package:flutter/material.dart';

import '../helpers/constants.dart';

Widget textController(
    {BuildContext? context,
    TextEditingController? controller,
    TextInputType? keyboardType,
    Function(String)? onChange,
    String? hintText,
    bool? enable,
    bool? obscureText,
    int? maxLines,
    String? validator}) {
  return Container(
    decoration: BoxDecoration(
      color: secondry,
      border: Border.all(color: secondry, width: 0.2),
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    ),
    child: TextFormField(
      controller: controller,
      onChanged: onChange,
      maxLines: maxLines,
      obscureText: obscureText == true ? true : false,
      enabled: enable,
      keyboardType: keyboardType,
      validator: (value) {
        if (value!.isEmpty) {
          return validator;
        }
        return null;
      },
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xffA6A6A6),
          fontWeight: FontWeight.w500,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: secondry, width: 0.2),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: secondry, width: 0.2),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: secondry, width: 0.2),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      ),
    ),
  );
}
