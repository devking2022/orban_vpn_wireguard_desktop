import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

Widget background_widget({required String assets, bool? full}) {
  return SizedBox(
    height: full == null ? Get.height / 1.8 : Get.height / 1.5,
    width: Get.width,
    child: Image.asset(
      assets,
      opacity: const AlwaysStoppedAnimation(.5),
      fit: BoxFit.fill,
    ),
  );
}

Widget background_animation({required String assets}) {
  return Column(
    children: [
      SizedBox(height: Get.height * 0.02),
      SizedBox(
        width: Get.width,
        height: Get.height / 1.5,
        child: LottieBuilder.asset(
          assets,
          fit: BoxFit.fill,
        ),
      ),
    ],
  );
}
