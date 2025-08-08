import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:open_share_plus/open.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/home_controller.dart';
import '../controllers/laungage_controller.dart';
import '../helpers/config.dart';
import '../helpers/constants.dart';
import '../helpers/my_dialogs.dart';
import '../helpers/pref.dart';
import '../services/api_services.dart';
import '../services/vpn_engine.dart';
import '../widgets/auth_card.dart';
import '../widgets/background_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/count_down_timer.dart';
import '../widgets/side_menu.dart';
import 'dns_screen.dart';
import 'location_screen.dart';
import 'network_test_screen.dart';
import 'setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  _HomeScreenState();
  final _controller = Get.put(HomeController());
  final api = Get.put(APIs());
  final LanguageController languageController = Get.put(LanguageController());

  String formatSpeed(double speedInKBps, {int decimals = 2}) {
    const suffixes = ["Byts", "KB/s", "MB/s", "GB/s", "TB/s"];

    if (speedInKBps < 1024) {
      return '${speedInKBps.toStringAsFixed(decimals)} ${suffixes[0]}';
    }

    int i = (log(speedInKBps) / log(1024)).floor();
    return '${(speedInKBps / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      return true;
    }
    MyDialogs.error(msg: 'No Internet Connection');
    return false;
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: background,
        automaticallyImplyLeading: false,
        leadingWidth: 80,
        leading: GestureDetector(
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: secondry, borderRadius: BorderRadius.circular(12)),
              child: Image.asset("assets/images/menu.png")),
        ),
        title: Text(Config.appName,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.15)),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Color(0xff333133).withOpacity(0.80),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ListView(
            children: [
              SizedBox(height: Get.height * 0.04),
              const AuthCard(),
              const Divider(),
              side_menu(
                  title: languageController.translate('account_management'),
                  onTap: () {
                    Get.back();
                    Get.to(() => const SettingScreen());
                  },
                  icon: MingCuteIcons.mgc_settings_1_line),
              side_menu(
                title: languageController.translate('connection_report'),
                onTap: () {
                  Get.to(() => const NetworkTestScreen());
                },
                icon: MingCuteIcons.mgc_earth_line,
              ),
              side_menu(
                  title: languageController.translate('dns_management'),
                  onTap: () {
                    Get.back();
                    Get.to(() => DnsScreen());
                  },
                  icon: MingCuteIcons.mgc_fingerprint_2_line),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    const Icon(MingCuteIcons.mgc_translate_2_line,
                        color: Colors.white),
                    const SizedBox(width: 10),
                    Text(languageController.translate('language'),
                        style: Get.theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: languageController.locale.languageCode,
                      items: const [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'fa',
                          child: Text('Persian'),
                        ),
                        DropdownMenuItem(
                          value: 'fr',
                          child: Text('French'),
                        ),
                        DropdownMenuItem(
                          value: 'de',
                          child: Text('German'),
                        ),
                        DropdownMenuItem(
                          value: 'es',
                          child: Text('Spanish'),
                        ),
                        DropdownMenuItem(
                          value: 'ru',
                          child: Text('Russian'),
                        ),
                        DropdownMenuItem(
                          value: 'ja',
                          child: Text('Japanese'),
                        ),
                        DropdownMenuItem(
                          value: 'ko',
                          child: Text('Korean'),
                        ),
                        DropdownMenuItem(
                          value: 'zh',
                          child: Text('Chinese'),
                        ),
                        DropdownMenuItem(
                          value: 'ar',
                          child: Text('Arabic'),
                        ),
                        DropdownMenuItem(
                          value: 'hi',
                          child: Text('Hindi'),
                        ),
                        DropdownMenuItem(
                          value: 'tr',
                          child: Text('Turkish'),
                        )
                      ],
                      onChanged: (value) {
                        languageController.changeLocale(value!);
                      },
                      dropdownColor: Color(0xff333133),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Divider(),
              side_menu(
                  title: languageController.translate('terms_&_policy'),
                  onTap: () {
                    Open.browser(url: Config.termsCondition);
                  },
                  icon: MingCuteIcons.mgc_question_line),
              side_menu(
                  title: languageController.translate('share'),
                  onTap: () {
                    Share.share(Pref.settingsModel.share.toString(),
                        subject: Pref.settingsModel.name);
                  },
                  icon: MingCuteIcons.mgc_share_2_line),
              side_menu(
                  title: languageController.translate('contact_support'),
                  onTap: () {
                    _showContactOptions(context);
                  },
                  icon: MingCuteIcons.mgc_message_3_line),
              SizedBox(height: Get.height * 0.04),
              ValueListenableBuilder(
                valueListenable: Hive.box(
                  'data',
                ).listenable(keys: ['isPremium']),
                builder: (context, Box box, _) {
                  return Pref.isPremium == false
                      ? button(
                          lable: languageController.translate(
                            'upgrade_to_premium',
                          ),
                          textColor: Colors.white,
                          onTap: () {
                            Open.browser(url: Config.hostUrl);
                          },
                        )
                      : Container();
                },
              ),
              SizedBox(height: Get.height * 0.04),
            ],
          ),
        ),
      ),
      body: _buildMapsWidget(),
    );
  }

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            if (Pref.settingsModel.whatsapp!.isNotEmpty)
              ListTile(
                leading: const Icon(MingCuteIcons.mgc_whatsapp_line),
                title: const Text('Whatsapp'),
                onTap: () {
                  Navigator.pop(context);
                  Open.browser(url: Pref.settingsModel.whatsapp.toString());
                },
              ),
            if (Pref.settingsModel.telegram!.isNotEmpty)
              ListTile(
                leading: const Icon(MingCuteIcons.mgc_telegram_line),
                title: const Text('Telegram'),
                onTap: () {
                  Navigator.pop(context);
                  Open.browser(url: Pref.settingsModel.telegram.toString());
                },
              ),
            if (Pref.settingsModel.email!.isNotEmpty)
              ListTile(
                leading: const Icon(MingCuteIcons.mgc_mail_line),
                title: const Text('Mail'),
                onTap: () {
                  Navigator.pop(context);
                  Open.mail(
                      toAddress: Pref.settingsModel.email.toString(),
                      subject: "${Pref.settingsModel.name} Support");
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildMapsWidget() {
    return Stack(
      children: [
        Obx(() => background_animation(
            assets: _controller.vpnState.value == VpnEngine.vpnConnected
                ? "assets/lottie/connected.json"
                : "assets/lottie/map.json")),
        GetBuilder<HomeController>(builder: (controller) {
          return Column(
            mainAxisAlignment: !Platform.isWindows
                ? MainAxisAlignment.end
                : MainAxisAlignment.center,
            children: [
              CountDownTimer(
                startTimer: controller.vpnState.value == VpnEngine.vpnConnected,
              ),
              SizedBox(height: Get.height * 0.04),
              if (!Platform.isWindows)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xff3A3A4D).withOpacity(0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              const Icon(
                                MingCuteIcons.mgc_arrow_down_line,
                                size: 20,
                                color: textSecondry,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                languageController.translate('download'),
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: textSecondry,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              formatSpeed(
                                double.parse(controller.downloadCount.value),
                              ),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade50),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xff3A3A4D).withOpacity(0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              const Icon(
                                MingCuteIcons.mgc_arrow_up_line,
                                size: 20,
                                color: textSecondry,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${languageController.translate('upload')}  ',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: textSecondry,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              formatSpeed(double.parse(
                                  controller.uploadCount.value.toString())),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              SizedBox(height: Get.height * 0.03),
              Semantics(
                button: true,
                child: GestureDetector(
                  onTap: () async {
                    bool isInternet = await checkInternetConnection();
                    if (isInternet) {
                      controller.connectToVpn(vpnModel: Pref.vpn);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _controller.getButtonColor.withOpacity(.1)),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _controller.getButtonColor.withOpacity(.3)),
                      child: Container(
                        width: Get.height * .14,
                        height: Get.height * .14,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _controller.getButtonColor),
                        child: const Icon(
                          MingCuteIcons.mgc_power_line,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.04),
              GestureDetector(
                onTap: () => Get.to(() => const LocationScreen()),
                child: Container(
                    decoration: BoxDecoration(
                        color: controller.getButtonColor.withOpacity(.1),
                        border: Border.all(
                            color: controller.getButtonColor.withOpacity(.3)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30))),
                    padding: EdgeInsets.symmetric(
                        horizontal: Get.width * .04,
                        vertical: Get.height * 0.02),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                    child: Row(
                      children: [
                        if (controller.vpn.value.server != null)
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            child: CountryFlag.fromCountryCode(
                              controller.vpn.value.server!.countryCode!
                                  .toUpperCase(),
                              shape: const Circle(),
                            ),
                          ),

                        if (controller.vpn.value.server == null)
                          const Icon(
                            Icons.vpn_lock_outlined,
                            size: 30,
                            color: Colors.white,
                          ),

                        const SizedBox(width: 10),

                        Text(
                          controller.vpn.value.server == null
                              ? languageController.translate('select_location')
                              : controller.vpn.value.server!.countryName
                                  .toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),

                        //for covering available spacing
                        const Spacer(),

                        //icon
                        const Icon(Icons.arrow_forward_outlined,
                            color: Colors.white, size: 25)
                      ],
                    )),
              ),
              SizedBox(height: Get.height * 0.06),
            ],
          );
        }),
      ],
    );
  }
}
