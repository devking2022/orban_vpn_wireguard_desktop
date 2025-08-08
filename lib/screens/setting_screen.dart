import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:orban_vpn_desktop/helpers/config.dart';
import 'package:open_share_plus/open.dart';

import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/laungage_controller.dart';
import '../helpers/constants.dart';
import '../helpers/pref.dart';
import '../widgets/auth_card.dart';
import 'account_screen.dart';
import 'network_test_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final LanguageController languageController = Get.put(LanguageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          languageController.translate('account_management'),
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Pref.isLoggedIn == false
            ? const Center(child: AuthCard())
            : Column(
                children: [
                  SizedBox(height: Get.height * 0.05),
                  Row(
                    children: [
                      SizedBox(width: Get.width * 0.05),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Pref.userModel.name.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            Pref.isPremium == true
                                ? languageController.translate('premium')
                                : languageController.translate('no_premium'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: Get.height * 0.05),
                  setting_card(
                    title: languageController.translate('my_account'),
                    onTap: () {
                      Get.to(const AccountScreen());
                    },
                    icon: MingCuteIcons.mgc_user_3_line,
                    showarrow: true,
                  ),
                  if (Pref.isPremium == false)
                    setting_card(
                      title: languageController.translate('subscription'),
                      onTap: () {
                        Open.browser(url: "${Config.hostUrl}/plan");
                      },
                      icon: MingCuteIcons.mgc_cash_line,
                      showarrow: true,
                    ),
                  setting_card(
                    title: languageController.translate('logout'),
                    onTap: () {
                      Get.dialog(CupertinoAlertDialog(
                        title: Text(
                            languageController.translate('confirm_logout')),
                        content:
                            Text(languageController.translate('logout_sure')),
                        actions: [
                          MaterialButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(languageController.translate('no'))),
                          MaterialButton(
                              onPressed: () {
                                HomeController().disConnect();
                                AuthController().logout();
                              },
                              child: Text(languageController.translate('yes'))),
                        ],
                      ));
                    },
                    icon: MingCuteIcons.mgc_exit_line,
                    showarrow: false,
                  ),
                ],
              ),
      )),
    );
  }
}

class setting_card extends StatelessWidget {
  const setting_card(
      {Key? key,
      required this.title,
      required this.icon,
      required this.showarrow,
      required this.onTap})
      : super(key: key);
  final String title;
  final IconData icon;
  final bool showarrow;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: const BoxDecoration(
            color: background,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: ListTile(
          leading: Icon(icon, color: Colors.white.withOpacity(.80)),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(.80)),
          ),
          trailing: showarrow == true
              ? Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: Colors.white.withOpacity(.80),
                  size: 30,
                )
              : null,
        ),
      ),
    );
  }
}
