import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/constants.dart';
import '../helpers/my_dialogs.dart';
import '../helpers/pref.dart';
import '../models/vpn.dart';
import '../services/vpn_engine.dart';
import '../services/system_tray_service.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

class HomeController extends GetxController {
  final Rx<Vpn> vpn = Pref.vpn.obs;
  final vpnState = VpnEngine.vpnDisconnected.obs;
  bool proxyOnly = false;
  final wireguard = WireGuardFlutter.instance;

  final RxString downloadCount = "0.0".obs;
  final RxString uploadCount = "0.0".obs;
  final RxString totalDownload = "0".obs;
  final RxString totalUpload = "0".obs;

  StreamSubscription? _vpnStatusSubscription;
  StreamSubscription? _vpnTraffic;

  Timer? _connectionTimer;
  final RxInt connectionTime = RxInt(Pref.totalConnectionTime);

  final List<String> logs = [];
  static const maxLogLines = 20;

  void startConnectionTimer() {
    _connectionTimer?.cancel(); // Cancel any existing timer
    _connectionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      connectionTime.value++; // Update observable time
      Pref.totalConnectionTime = connectionTime.value; // Save updated time
      if (!Platform.isWindows) {
        Pref.totalDataUsage =
            int.parse(totalDownload.value) + int.parse(totalUpload.value);
      }
    });
  }

  Future<void> initialize() async {
    try {
      await wireguard.initialize(interfaceName: "my_wg_vpn");
      debugPrint("initialize success my_wg_vpn");
    } catch (error, stack) {
      debugPrint("failed to initialize: $error\n$stack");
    }
  }

  void disConnect() async {
    // Cancel the timer immediately on disconnection
    print("Disconnecting VPN and canceling the timer.");
    _connectionTimer?.cancel(); // Stop timer when VPN disconnects
    connectionTime.value = 0; // Reset connection time
    Pref.totalConnectionTime = connectionTime.value; // Save final time

    Pref.isVpnConnected = false; // Update the connection status
    vpnState.value = VpnEngine.vpnDisconnected; // Update VPN state

    try {
      await wireguard.stopVpn();
      if (Platform.isWindows) {
        final result = await Process.run('sc', ['DELETE', 'my_wg_vpn']);
        if (result.exitCode == 0) {
          print('Service my_wg_vpn deleted successfully');
        } else {
          print('Failed to delete service my_wg_vpn: ${result.stderr}');
        }
      }
    } catch (e, str) {
      debugPrint('Failed to disconnect $e\n$str');
    }
    
    // Update system tray menu
    await SystemTrayService.to.updateTrayMenu();
  }

  void connectToVpn({required Vpn vpnModel}) async {
    if (vpnModel.responseData!.success == false) {
      MyDialogs.error(msg: 'Please select server location');
      return;
    }

    if (vpnState.value == VpnEngine.vpnDisconnected) {
      Pref.isVpnConnected = true;
      connect(
        serverAddress: vpnModel.responseData!.obj!.wireguardConfig.toString(),
      );
    } else if (vpnState.value == VpnEngine.vpnConnected) {
      disConnect();
    }
  }

  Future<void> connect({required String serverAddress}) async {
    print(serverAddress);

    try {
      await wireguard.startVpn(
        serverAddress:
            vpn.value.server!.countryName.toString(), // Change as needed
        wgQuickConfig: serverAddress, // Use user-provided config
        providerBundleIdentifier: 'com.orbanvpn.wireguard.WGExtension',
      );
    } catch (error, stack) {
      debugPrint("failed to start $error\n$stack");
    }
    startConnectionTimer();
    
    // Update system tray menu
    await SystemTrayService.to.updateTrayMenu();
  }

  // vpn buttons color
  Color get getButtonColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return blue;

      case VpnEngine.vpnConnected:
        return primery;

      default:
        return orange;
    }
  }

  // vpn button text
  String get getButtonText {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return 'Start';

      case VpnEngine.vpnConnected:
        return 'Disconnect';

      default:
        return 'Connecting...';
    }
  }

  // vpn buttons color
  Color get getTextColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Colors.red;

      case VpnEngine.vpnConnected:
        return Colors.green;

      default:
        return Colors.orangeAccent;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initialize();
    wireguard.vpnStageSnapshot.listen((event) {
      debugPrint("status changed $event");

      vpnState.value = event.name;

      update();
    });

    _vpnTraffic = wireguard.trafficSnapshot.listen((data) async {
      debugPrint("Traffic $data");
      downloadCount.value = data["downloadSpeed"].toString();
      uploadCount.value = data["uploadSpeed"].toString();
      totalDownload.value = data["totalDownload"].toString();
      totalUpload.value = data["totalUpload"].toString();
      update();
    });

    // Initialize system tray service after HomeController is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        Get.put(SystemTrayService());
      } catch (e) {
        debugPrint('Failed to initialize SystemTrayService: $e');
      }
    });
  }

  @override
  void onClose() {
    _connectionTimer?.cancel();
    _vpnStatusSubscription?.cancel(); // Ensure subscription is disposed
    _vpnTraffic?.cancel();
    super.onClose();
  }
}
