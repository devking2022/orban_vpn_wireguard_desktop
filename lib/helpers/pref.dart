import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/settings_model.dart';
import '../models/user_model.dart';
import '../models/vpn.dart';

class Pref {
  static late Box _box;

  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('data');
  }

  static Future<void> deleteAllData() async {
    _box.clear();
  }

  //for storing theme data
  static bool get isDarkMode => _box.get('isDarkMode') ?? false;
  static set isDarkMode(bool v) => _box.put('isDarkMode', v);

  //for storing theme data
  static bool get isIntro => _box.get('isIntro') ?? false;
  static set isIntro(bool v) => _box.put('isIntro', v);

  //for storing premium data
  static bool get isPremium => _box.get('isPremium') ?? false;
  static set isPremium(bool v) => _box.put('isPremium', v);

  //for storing premium data
  static bool get isFreePremium => _box.get('isFreePremium') ?? false;
  static set isFreePremium(bool v) => _box.put('isFreePremium', v);

  //for storing premium data
  static String get expiryDate =>
      _box.get('expiryDate') ?? DateTime.now().toString();
  static set expiryDate(String v) => _box.put('expiryDate', v);

  //for storing single selected vpn details
  static Vpn get vpn => Vpn.fromJson(jsonDecode(_box.get('vpn') ?? '{}'));
  static set vpn(Vpn v) => _box.put('vpn', jsonEncode(v));

  //for storing premium data
  static String get lan => _box.get('lan') ?? "en";
  static set lan(String v) => _box.put('lan', v);

  //for storing Token data
  static String get token => _box.get('token') ?? "";
  static set token(String v) => _box.put('token', v);

  // for storing Alloed Apps servers details
  static List<String> get allowedApps {
    List<String> temp = [];
    final data = jsonDecode(_box.get('allowedApps') ?? '[]');

    for (var i in data) {
      temp.add(i);
    }

    return temp;
  }

  static set allowedApps(List<String> v) =>
      _box.put('allowedApps', jsonEncode(v));

  //for storing single selected vpn details
  static SettingsModel get settingsModel =>
      SettingsModel.fromJson(jsonDecode(_box.get('settingsModel') ?? '{}'));
  static set settingsModel(SettingsModel v) =>
      _box.put('settingsModel', jsonEncode(v));

  //for storing user data
  static UserModel get userModel =>
      UserModel.fromJson(jsonDecode(_box.get('userData') ?? '{}'));
  static set userModel(UserModel v) => _box.put('userData', jsonEncode(v));

// Check if user is logged in
  static bool get isLoggedIn => userModel.status == 0 ? true : false;

// Clear Auth Data
  static Future<void> clearAuthData() async {
    await _box.delete('authToken');
    await _box.delete('userData'); // Clear user data
    deleteAllData();
  }

  // Track VPN state
  static bool get isVpnConnected => _box.get('isVpnConnected') ?? false;
  static set isVpnConnected(bool v) => _box.put('isVpnConnected', v);

// Store last active timestamp
  static int get lastActiveTimestamp => _box.get('lastActiveTimestamp') ?? 0;
  static set lastActiveTimestamp(int v) => _box.put('lastActiveTimestamp', v);

// Available time in seconds
  static int get availableTime => _box.get('availableTime') ?? 0;
  static set availableTime(int v) => _box.put('availableTime', v);

  // Available time in seconds
  static int get rechargeTime => _box.get('rechargeTime') ?? 0;
  static set rechargeTime(int v) => _box.put('rechargeTime', v);

  // Total connection time in seconds
  static int get totalConnectionTime => _box.get('totalConnectionTime') ?? 0;
  static set totalConnectionTime(int v) => _box.put('totalConnectionTime', v);

  static int get totalDataUsage => _box.get('totalDataUsage') ?? 0;
  static set totalDataUsage(int v) => _box.put('totalDataUsage', v);

  // For VPN toggle state
  static String get isVPNMode => _box.get('isVPNMode') ?? 'System Proxy';
  static set isVPNMode(String value) => _box.put('isVPNMode', value);

  // For DNS toggle state
  static bool get isDnsEnabled => _box.get('isDnsEnabled') ?? false;
  static set isDnsEnabled(bool value) => _box.put('isDnsEnabled', value);

// For DNS records
  static String get dnsRecord => _box.get('dnsRecord') ?? '1.1.1.1';
  static set dnsRecord(String v) => _box.put('dnsRecord', v);

  // For admin permissions
  static bool get hasAdminPermissions => _box.get('hasAdminPermissions') ?? false;
  static set hasAdminPermissions(bool v) => _box.put('hasAdminPermissions', v);

  // For window state
  static bool get wasMinimizedOnClose => _box.get('wasMinimizedOnClose') ?? false;
  static set wasMinimizedOnClose(bool v) => _box.put('wasMinimizedOnClose', v);

  // For startup behavior
  static bool get startMinimized => _box.get('startMinimized') ?? false;
  static set startMinimized(bool v) => _box.put('startMinimized', v);
}
