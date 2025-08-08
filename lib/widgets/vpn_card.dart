import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

import '../controllers/home_controller.dart';
import '../controllers/laungage_controller.dart';
import '../helpers/constants.dart';
import '../helpers/my_dialogs.dart';
import '../helpers/pref.dart';
import '../models/vpn.dart';
import '../services/vpn_engine.dart';

class VpnCard extends StatelessWidget {
  final Vpn vpn;

  const VpnCard({Key? key, required this.vpn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lanController = Get.find<LanguageController>();
    final controller = Get.find<HomeController>();
    void connect() {
      controller.vpn.value = vpn;
      Pref.vpn = vpn;
      Get.back();
      if (controller.vpnState.value == VpnEngine.vpnConnected) {
        Future.delayed(const Duration(seconds: 2),
            () => controller.connectToVpn(vpnModel: vpn));
      } else {
        controller.connectToVpn(vpnModel: vpn);
      }
    }

    return InkWell(
      onTap: () {
        if (Pref.isPremium == true) {
          connect();
        } else if (vpn.server!.provideTo == true && Pref.isPremium == false) {
          MyDialogs()
              .subscriptionDailog(context: context, controller: lanController);
        } else if (vpn.server!.provideTo == false) {
          connect();
        }
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: secondry,
              border: Border.all(
                  color: Pref.vpn.id != vpn.id
                      ? const Color(0xff4A4A61)
                      : primery.withOpacity(.75)),
              borderRadius: BorderRadius.circular(12)),
          child: ListTile(
              //flag
              leading: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: CountryFlag.fromCountryCode(
                  vpn.server!.countryCode!.toUpperCase(),
                  shape: const Circle(),
                ),
              ),

              //title
              title: Text(
                vpn.server!.countryName.toString(),
                style: const TextStyle(fontSize: 16),
              ),

              //trailing
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  vpn.server!.provideTo == true
                      ? const Icon(
                          MingCuteIcons.mgc_diamond_2_line,
                          size: 25,
                        )
                      : Container(),
                  const SizedBox(width: 10),
                  Pref.vpn.id != vpn.id
                      ? const Icon(
                          Icons.circle_outlined,
                          color: Color(0xff4A4A61),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: primery.withOpacity(.50),
                              shape: BoxShape.circle),
                          padding: const EdgeInsets.all(5),
                          child: const Icon(
                            Icons.circle,
                            size: 15,
                            color: primery,
                          ),
                        )
                ],
              ))),
    );
  }
}
