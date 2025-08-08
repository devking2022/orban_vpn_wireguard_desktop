import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

import '../controllers/laungage_controller.dart';
import '../helpers/constants.dart';
import '../models/ip_details.dart';
import '../models/network_data.dart';
import '../services/api_services.dart';
import '../widgets/network_card.dart';

class NetworkTestScreen extends StatelessWidget {
  const NetworkTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController = Get.put(LanguageController());
    final ipData = IPDetails.fromJson({}).obs;
    APIs.getIPDetails(ipData: ipData);

    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: context.theme.scaffoldBackgroundColor,
          centerTitle: true,
          title: Text(languageController.translate('connection_report'))),

      //refresh button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
            backgroundColor: primery,
            onPressed: () {
              ipData.value = IPDetails.fromJson({});
              APIs.getIPDetails(ipData: ipData);
            },
            child: const Icon(MingCuteIcons.mgc_refresh_2_line,
                color: Colors.white)),
      ),

      body: Obx(
        () => ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
                left: Get.width * .04,
                right: Get.width * .04,
                top: Get.height * .01,
                bottom: Get.height * .1),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: secondry,
                          borderRadius: BorderRadius.circular(15)),
                      child: const Icon(MingCuteIcons.mgc_earth_line,
                          size: 45, color: primery)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  languageController.translate('report_des'),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              //ip
              NetworkCard(
                  data: NetworkData(
                      title: languageController.translate('ip_address'),
                      subtitle: ipData.value.query,
                      icon: const Icon(MingCuteIcons.mgc_iMac_line,
                          color: Colors.white))),

              //isp
              NetworkCard(
                  data: NetworkData(
                      title: languageController.translate('internet_provider'),
                      subtitle: ipData.value.isp,
                      icon: const Icon(MingCuteIcons.mgc_world_2_line,
                          color: Colors.white))),

              //location
              NetworkCard(
                  data: NetworkData(
                      title: languageController.translate('location'),
                      subtitle: ipData.value.country.isEmpty
                          ? 'Fetching ...'
                          : '${ipData.value.city}, ${ipData.value.regionName}, ${ipData.value.country}',
                      icon: const Icon(MingCuteIcons.mgc_location_line,
                          color: Colors.white))),

              //pin code
              NetworkCard(
                  data: NetworkData(
                      title: languageController.translate('pin_code'),
                      subtitle: ipData.value.zip,
                      icon: const Icon(MingCuteIcons.mgc_map_pin_line,
                          color: Colors.white))),

              //timezone
              NetworkCard(
                  data: NetworkData(
                      title: languageController.translate('timezone'),
                      subtitle: ipData.value.timezone,
                      icon: const Icon(MingCuteIcons.mgc_alarm_2_line,
                          color: Colors.white))),
            ]),
      ),
    );
  }
}
