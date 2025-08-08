import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:intl/intl.dart';
import '../controllers/laungage_controller.dart';
import '../helpers/constants.dart';
import '../helpers/pref.dart';
import '../services/api_services.dart';
import '../widgets/auth_card.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final LanguageController languageController = Get.put(LanguageController());
  String deviceName = "";
  String deviceId = "";
  @override
  void initState() {
    super.initState();
    getDeviceData();
  }

  getDeviceData() async {
    deviceId = await APIs().getDeviceId();
    deviceName = await APIs().getDeviceName();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          languageController.translate('my_account'),
          style: const TextStyle(fontSize: 18),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const AuthCard(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: secondry,
                  borderRadius: BorderRadius.all(Radius.circular(24))),
              child: Column(
                children: [
                  ListTile(
                    horizontalTitleGap: 10,
                    leading: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.all(5),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: primery,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(MingCuteIcons.mgc_diamond_2_line)),
                    title: Text(
                      Pref.isPremium == true
                          ? languageController.translate('premium')
                          : languageController.translate('no_premium'),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    subtitle: Text(
                      Pref.isPremium == true
                          ? languageController.translate('premium')
                          : languageController
                              .translate('subscription_not_active'),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: textSecondry),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    horizontalTitleGap: 10,
                    minLeadingWidth: 10,
                    leading: const Icon(MingCuteIcons.mgc_profile_fill),
                    title: Text(
                      languageController.translate('user_id'),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: textSecondry),
                    ),
                    subtitle: Text(
                      Pref.userModel.id.toString(),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 10,
                    minLeadingWidth: 10,
                    leading: const Icon(MingCuteIcons.mgc_calendar_2_line),
                    title: Text(
                      languageController.translate('expiry_date'),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: textSecondry),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMMd()
                          .format(DateTime.parse(Pref.expiryDate)),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 10,
                    minLeadingWidth: 10,
                    leading: const Icon(MingCuteIcons.mgc_device_fill),
                    title: Text(
                      languageController.translate('devices'),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: textSecondry),
                    ),
                    subtitle: Text(
                      deviceName + " - " + deviceId,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
