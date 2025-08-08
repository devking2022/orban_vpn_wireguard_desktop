import 'package:flutter/material.dart';
import 'package:get/get.dart';

//card to represent status in home screen
class HomeCard extends StatelessWidget {
  final String title, subtitle;
  final Widget icon;

  const HomeCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Get.width * .45,
        child: Column(
          children: [
            //icon
            icon,

            //for adding some space
            const SizedBox(height: 6),

            //title
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

            //for adding some space
            const SizedBox(height: 6),

            //subtitle
            Text(
              subtitle,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
            ),
          ],
        ));
  }
}
