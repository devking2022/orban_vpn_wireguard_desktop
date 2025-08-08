import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../controllers/home_controller.dart';
import '../helpers/config.dart';
import '../helpers/my_dialogs.dart';
import '../helpers/pref.dart';
import '../models/ip_details.dart';
import '../models/settings_model.dart';
import '../models/user_model.dart';
import '../models/vpn.dart';

class APIs extends GetxController {
  RxBool loading = false.obs;
  List<Vpn> vpnList = [];
  String token = Pref.token;
  HomeController homeController = Get.find<HomeController>();

  static Future<void> getIPDetails({required Rx<IPDetails> ipData}) async {
    try {
      final res = await http.get(Uri.parse('http://ip-api.com/json/'));
      final data = jsonDecode(res.body);
      log(data.toString());
      ipData.value = IPDetails.fromJson(data);
    } catch (e) {
      MyDialogs.error(msg: e.toString());
      log('\ngetIPDetailsE: $e');
    }
  }

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor.toString();
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.deviceId;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macOsDeviceInfo = await deviceInfo.macOsInfo;
      return macOsDeviceInfo.systemGUID.toString();
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    }
  }

  Future<String> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model.toString();
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.userName;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macOsDeviceInfo = await deviceInfo.macOsInfo;
      return macOsDeviceInfo.computerName.toString();
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    }
  }

  // Future<void> defaultServer() async {
  //   if (homeController.vpn.value.id.isEmpty || Pref.vpn.id.isEmpty) {
  //     try {
  //       loading.value = true;
  //       update();
  //       final response = await http.get(
  //         Uri.parse(Config.apiUrl + 'server/free'),
  //         headers: {'Content-Type': 'application/json'},
  //       );
  //       if (response.statusCode == 200) {
  //         final data = jsonDecode(response.body) as List<dynamic>;
  //         if (data.isNotEmpty) {
  //           Vpn model = Vpn.fromJson(data[0] as Map<String, dynamic>);
  //           Pref.vpn = model;
  //           homeController.vpn.value = model;
  //           loading.value = false;
  //           update();
  //         } else {
  //           print('No servers found in response.');
  //           loading.value = false;
  //           update();
  //         }
  //       } else {
  //         print('Request failed with status: ${response.statusCode}');
  //       }
  //     } catch (e) {
  //       print('Error fetching default server: $e');
  //     } finally {
  //       loading.value = false;
  //       update();
  //     }
  //   }
  // }

  Future<void> loadData() async {
    try {
      loading.value = true;
      update();

      http.Response response = await http.get(
          Uri.parse(Config.apiUrl + 'setting-data'),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data.isNotEmpty) {
          SettingsModel model = SettingsModel.fromJson(data);
          Pref.settingsModel = model;
          loading.value = false;
          update();
        } else {
          Get.snackbar('Error', 'No data found in response.');
          print('No data found in response.');
          loading.value = false;
          update();
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching default server: $e');
    } finally {
      loading.value = false;
      update();
    }
  }

  Future<void> loadServers() async {
    String deviceId = await APIs().getDeviceId();
    String userId = "";
    if (Pref.isLoggedIn) {
      userId = Pref.userModel.id;
    }
    try {
      loading.value = true;
      update();

      http.Response response = await http.post(
        Uri.parse(Config.apiUrl + 'server/all-config'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'device_id': deviceId, 'user_id': userId}),
      );

      final data = jsonDecode(response.body) as List<dynamic>;
      print(data);
      if (response.statusCode == 200) {
        vpnList = data.map((vpn) => Vpn.fromJson(vpn)).toList();

        loading.value = false;
        update();
      } else {
        loading.value = false;
        vpnList = [];
        update();
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      loading.value = false;
      vpnList = [];
      update();
      print('Error loading servers: $e');
    } finally {
      loading.value = false;
      update();
    }
  }

  Future<void> subscriptionSuccess(
      {required String userId,
      required String productId,
      required String paymentId,
      required String plan,
      required String mathord,
      required String duration,
      required String price,
      required String priceType}) async {
    loading.value = true;
    update();
    var request = http.MultipartRequest(
        'POST', Uri.parse(Config.apiUrl + 'user-subscriptionn'));
    // Add Bearer token to the headers
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type':
          'application/json', // Optional: adjust based on your backend
    });
    request.fields.addAll({
      'user_id': userId,
      'order_id': productId,
      'payment_id': paymentId,
      'plan_id': paymentId,
      'title': plan,
      'duration': duration,
      'price': price,
      'discount_price': price,
      'payment_method': mathord,
      'active': '1',
      'price_type': priceType,
      'payment_status': "success",
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      var body = await response.stream.bytesToString();

      final data = jsonDecode(body) as Map<String, dynamic>;
      print(data);
      if (data['type'] == "success") {
        Pref.isPremium = true;
        MyDialogs.success(msg: 'You are subscribed user now...');
        checkSubscription();
        loading.value = false;
        update();
      }
    } else {
      print(response.reasonPhrase);
      print('Request failed with status: ${response.statusCode}');
      loading.value = false;
      MyDialogs.error(msg: 'Subscription failed');
      update();
    }
    Get.back();
  }

  Future<void> checkSubscription() async {
    if (Pref.isLoggedIn == false) {
      return;
    }
    print('user id: ${Pref.userModel.id}');
    try {
      loading.value = true;
      update();

      http.Response response = await http.get(
          Uri.parse(Config.apiUrl + 'users/${Pref.userModel.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        print(data);

        if (data["status"] == 0) {
          Pref.userModel = UserModel.fromJson(data);
          Pref.isPremium = Pref.userModel.isSubscribed!;
          Pref.totalDataUsage = data['data_use'] ?? Pref.totalDataUsage;
          Pref.totalConnectionTime =
              data['time_duration'] ?? Pref.totalConnectionTime;

          if (data['payment_method'] == "Free") {
            Pref.isFreePremium = true;
            Pref.isPremium = false;
          } else {
            Pref.isPremium = Pref.userModel.isSubscribed!;
            Pref.isFreePremium = Pref.userModel.isSubscribed!;
          }
          loading.value = false;
          update();
        }

        loading.value = false;
        update();
      } else {
        print('Request failed with status: ${response.statusCode}');
        loading.value = false;
        Pref.isPremium = false;
        update();
      }
    } catch (e) {
      print('Error fetching default server: $e');
    } finally {
      loading.value = false;
      update();
    }
  }

  // Future<void> deviceStatus() async {
  //   String deviceId = await APIs().getDeviceId();
  //   String deviceName = await APIs().getDeviceName();
  //   if (Pref.isLoggedIn == true) {
  //     return;
  //   }
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${Config.apiUrl}device-subscription'),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         'data_use': Pref.totalDataUsage,
  //         'time_duration': Pref.totalConnectionTime,
  //         'device_id': deviceId,
  //         'device_name': deviceName
  //       }),
  //     );
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print(data);
  //       // Store user data and token
  //       Pref.isFreePremium = data['isSubscribed'] as bool;
  //       if (data['isSubscribed'] == false && Pref.isLoggedIn == false) {
  //         MyDialogs()
  //             .signupDailog(context: Get.context!, controller: Get.find());
  //       }
  //       update();
  //     } else {
  //       print('Request failed with status: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Request failed with status: ${e.toString()}');
  //   }
  // }

  Future<void> createServerForDevice() async {
    String deviceId = await APIs().getDeviceId();
    if (Pref.isLoggedIn == true) {
      return;
    }
    try {
      final response = await http.post(
        Uri.parse('${Config.apiUrl}server/create-server-for-device'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'device_id': deviceId}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print(data);

        update();
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Request failed with status: ${e.toString()}');
    }
  }

  Future<void> updateUserForDevice({
    required String userId,
    required String tokenData,
  }) async {
    String deviceId = await APIs().getDeviceId();

    try {
      final response = await http.post(
        Uri.parse('${Config.apiUrl}server/update-server-device-to-user'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $tokenData',
        },
        body: jsonEncode({'device_id': deviceId, 'user_id': userId}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print(data);

        update();
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Request failed with status: ${e.toString()}');
    }
  }

  Future<void> createUserForDevice({
    required String userId,
    required String tokenData,
  }) async {
    print("calling  updateUserForDevice");
    try {
      final response = await http.post(
        Uri.parse('${Config.apiUrl}server/create-server-for-user'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $tokenData',
        },
        body: jsonEncode({'user_id': userId}),
      );
      final data = jsonDecode(response.body);

      print(data);
      if (response.statusCode == 200) {
        update();
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Request failed with status: ${e.toString()}');
    }
  }

  @override
  void onInit() {
    loadData();
    //defaultServer();
    checkSubscription();
    //deviceStatus();
    createServerForDevice();

    super.onInit();
  }
}
