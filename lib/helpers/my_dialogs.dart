import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orban_vpn_desktop/helpers/constants.dart';
import 'package:orban_vpn_desktop/screens/signup_screen.dart';
import 'package:open_share_plus/open.dart';

import '../controllers/laungage_controller.dart';
import 'pref.dart';

class MyDialogs {
  static success({required String msg}) {
    Get.snackbar('Success', msg,
        colorText: Colors.white, backgroundColor: Colors.green.withOpacity(.9));
  }

  static error({required String msg}) {
    Get.snackbar('Error', msg,
        colorText: Colors.white,
        backgroundColor: Colors.redAccent.withOpacity(.9));
  }

  static info({required String msg}) {
    Get.snackbar('Info', msg, colorText: Colors.white);
  }

  static showProgress() {
    Get.dialog(const Center(child: CircularProgressIndicator(strokeWidth: 2)));
  }

  subscriptionDailog(
      {required BuildContext context,
      required LanguageController controller}) async {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 800),
      transitionBuilder: (ctx, a1, a2, child) {
        var animation = Tween(begin: -200.0, end: 0.0).animate(a1);

        return Transform.translate(
          offset: Offset(0.0, animation.value),
          child: _filterWidget(context, controller),
        );
      },
      pageBuilder: (BuildContext context, a1, a2) {
        return Container();
      },
    );
  }

  Widget _filterWidget(BuildContext context, LanguageController controller) {
    var theme = context.theme;

    return Hero(
      tag: 'filter',
      child: StatefulBuilder(
        builder: (BuildContext context, setstate) {
          return AlertDialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            insetPadding: EdgeInsets.zero,
            actionsPadding: const EdgeInsets.only(right: 14),
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ListBody(
                  children: <Widget>[
                    SizedBox(height: Get.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.shopping_cart,
                                color: Get.theme.colorScheme.onPrimary),
                            SizedBox(width: Get.width * 0.03),
                            Text(
                              controller.translate('subscription'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Get.theme.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.close))
                      ],
                    ),
                    SizedBox(height: Get.height * 0.01),
                    const Divider(),
                    Text(
                      controller.translate('upgrade_to_premium'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.01),
                    Text(
                      controller.translate('access_all_server_worldwide'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: CupertinoColors.activeBlue.withOpacity(.1)),
                        child: const Icon(Icons.block),
                      ),
                      title: Text(controller.translate('no_ads')),
                      subtitle: Text(controller.translate('enjoy_ads')),
                    ),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: CupertinoColors.activeBlue.withOpacity(.1)),
                        child: const Icon(Icons.rocket_launch),
                      ),
                      title: Text(controller.translate('fast')),
                      subtitle: Text(
                          controller.translate('increase_connection_speed')),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    InkWell(
                      onTap: () {
                        Open.browser(url: Pref.settingsModel.url.toString());
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: Get.height * 0.05,
                        decoration: const BoxDecoration(
                            color: Colors.amber,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Text(
                          controller.translate('buy_now'),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  signupDailog(
      {required BuildContext context,
      required LanguageController controller}) async {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 800),
      transitionBuilder: (ctx, a1, a2, child) {
        var animation = Tween(begin: -200.0, end: 0.0).animate(a1);

        return Transform.translate(
          offset: Offset(0.0, animation.value),
          child: _signupWidget(context, controller),
        );
      },
      pageBuilder: (BuildContext context, a1, a2) {
        return Container();
      },
    );
  }

  Widget _signupWidget(BuildContext context, LanguageController controller) {
    var theme = context.theme;

    return Hero(
      tag: 'signup',
      child: StatefulBuilder(
        builder: (BuildContext context, setstate) {
          return AlertDialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            insetPadding: EdgeInsets.zero,
            actionsPadding: const EdgeInsets.only(right: 14),
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ListBody(
                  children: <Widget>[
                    SizedBox(height: Get.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.translate('welcome_back'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Get.theme.colorScheme.onPrimary,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.close))
                      ],
                    ),
                    SizedBox(height: Get.height * 0.01),
                    const Divider(),
                    Text(
                      controller.translate('trial_off'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.01),
                    Text(
                      controller.translate('please_register'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    InkWell(
                      onTap: () {
                        Get.to(const SignUpScreen(),
                            arguments: {'signup': true});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: Get.height * 0.05,
                        decoration: const BoxDecoration(
                            color: primery,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Text(
                          controller.translate('register'),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
