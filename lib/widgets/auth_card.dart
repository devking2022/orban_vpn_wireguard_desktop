import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

import '../controllers/laungage_controller.dart';
import '../helpers/constants.dart';
import '../helpers/pref.dart';
import '../screens/signin_screen.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final LanguageController languageController = Get.put(LanguageController());
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: tertiary.withOpacity(0.60), shape: BoxShape.circle),
            child: Pref.isLoggedIn == false
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        color: textSecondry, shape: BoxShape.circle),
                    child: const Icon(
                      MingCuteIcons.mgc_user_4_line,
                      size: 50,
                    ),
                  )
                : Column(
                    children: [
                      if (Pref.userModel.image == null)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                              color: tertiary, shape: BoxShape.circle),
                          child: const Icon(
                            MingCuteIcons.mgc_user_4_line,
                            size: 50,
                          ),
                        ),
                      if (Pref.userModel.image != null)
                        CircleAvatar(
                          radius: 45,
                          backgroundImage:
                              NetworkImage(Pref.userModel.image.toString()),
                        )
                    ],
                  ),
          ),
          if (Pref.isLoggedIn)
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(
                Pref.userModel.name.toString(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Text(
                Pref.userModel.email.toString(),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: textSecondry),
              ),
            ]),
          if (!Pref.isLoggedIn)
            Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(const SignInScreen());
                  },
                  child: Container(
                    height: Get.height * 0.06,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(40)),
                    alignment: Alignment.center,
                    child: Text(
                      languageController.translate('sign_in'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
