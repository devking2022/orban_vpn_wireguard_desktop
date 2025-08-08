import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/laungage_controller.dart';
import '../services/api_services.dart';
import '../widgets/vpn_card.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LanguageController languageController = Get.put(LanguageController());
  final APIs _apIs = Get.put(APIs());

  @override
  void initState() {
    super.initState();
    _apIs.loadServers();
  }

  Future<void> _refreshServers() async {
    await _apIs.loadServers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          languageController.translate('locations'),
          style: const TextStyle(fontSize: 18),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _refreshServers,
        child: _vpnData(),
      ),
    );
  }

  _vpnData() => GetBuilder<APIs>(builder: (api) {
        if (api.loading.value == true) {
          return _loadingWidget();
        }
        if (api.vpnList.isEmpty) {
          return _noVPNFound();
        }
        return ListView.builder(
            itemCount: api.vpnList.length,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
                top: Get.height * .015,
                bottom: Get.height * .1,
                left: Get.width * .04,
                right: Get.width * .04),
            itemBuilder: (ctx, i) {
              return VpnCard(vpn: api.vpnList[i]);
            });
      });

  _loadingWidget() => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //lottie animation
            LottieBuilder.asset(
              'assets/lottie/loading.json',
              width: Get.width * .7,
              height: Get.height / 2,
            ),

            //text
            Text(
              languageController.translate('loading_vpns'),
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  _noVPNFound() => Center(
        child: Text(
          languageController.translate('vpn_not_found'),
          style: const TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
}
