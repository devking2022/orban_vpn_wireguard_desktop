import 'package:get/get.dart';

class VpnEngine extends GetxController {
  ///All Stages of connection
  static const String vpnConnecting = "connecting";
  static const String vpnConnected = "connected";
  static const String vpnDisconnecting = "disconnecting";
  static const String vpnDisconnected = "disconnected";
  static const String vpnWaitConnection = "waitingConnection";
  static const String vpnAuthenticating = "authenticating";
  static const String vpnReconnect = "reconnect";
  static const String vpnNoConnection = "noConnection";
  static const String vpnPrepare = "preparing";
  static const String vpnDenied = "denied";
  static const String vpnExiting = "exiting";
}
