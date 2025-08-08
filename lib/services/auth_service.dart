import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orban_vpn_desktop/helpers/constants.dart';

import '../helpers/config.dart';
import '../helpers/pref.dart';
import '../models/user_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_services.dart';

class AuthService {
  // Login Function
  Future<UserModel?> login(String email, String password) async {
    String deviceId = await APIs().getDeviceId();
    String deviceName = await APIs().getDeviceName();
    try {
      final response = await http.post(
        Uri.parse('${Config.apiUrl}login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email,
          'password': password,
          'device_id': deviceId,
          'device_name': deviceName,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Pref.token = data['token'] ?? '';
        print(data);
        if (data['user']['status'] == 0) {
          final user = UserModel.fromJson(data);
          APIs().updateUserForDevice(
            userId: data['user']['id'].toString(),
            tokenData: data['token'].toString(),
          );
          // Store user data and token
          Pref.userModel = user;
          Pref.totalDataUsage = user.dataUse as int;
          Pref.totalConnectionTime = user.timeDuration as int;
          APIs().checkSubscription(); // Check subscription status
          return user;
        } else {
          return null;
        }
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar(
          'Login Failed',
          data['text'],
          colorText: textPrimery,
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint('Login Failed: $e');
    }
  }

  // Forgot Function
  Future<Map<String, dynamic>?> forgotSendOTP({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.apiUrl}forget-password-get-otp'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // print(data);
        if (data['type'] == 'success') {
          return data;
        } else {
          Get.snackbar(
            'Send OTP Failed',
            data['text'],
            colorText: textPrimery,
            snackPosition: SnackPosition.BOTTOM,
          );
          return {};
        }
      }
    } catch (e) {
      Get.snackbar(
        'Send OTP Failed',
        e.toString(),
        colorText: textPrimery,
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint('Send OTP Failed: $e');
    }
    return null;
  }

  // Forgot Function
  Future<Map<String, dynamic>?> forgotAccount({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.apiUrl}forget-password-update'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // print(data);
        if (data['type'] == 'success') {
          return data;
        } else {
          Get.snackbar(
            'Forgot Password Failed',
            data['text'],
            colorText: textPrimery,
            snackPosition: SnackPosition.BOTTOM,
          );
          return {};
        }
      }
    } catch (e) {
      Get.snackbar(
        'Forgot Password Failed',
        e.toString(),
        colorText: textPrimery,
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint('Forgot Password Failed: $e');
    }
    return null;
  }

  // Registration Function
  Future<UserModel?> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
  }) async {
    String deviceId = await APIs().getDeviceId();
    String deviceName = await APIs().getDeviceName();
    try {
      // Send POST request to API
      final response = await http.post(
        Uri.parse('${Config.apiUrl}register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
          'name': name,
          'device_id': deviceId,
          'device_name': deviceName,
        }),
      );

      final data = jsonDecode(response.body);
      print(data);

      // Parse response
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Check if the API response is successful
        if (data['type'] == 'success') {
          // Automatically log in the user after registration

          var user = await login(email, password);
          return user;
        } else {
          // Show error message if registration fails
          String errorMessage = 'Something went wrong!';
          if (data['text'] is List) {
            errorMessage = (data['text'] as List).join('\n');
          } else if (data['text'] is String) {
            errorMessage = data['text'];
          }

          Get.snackbar(
            'Registration Failed',
            errorMessage,
            colorText: textPrimery,
            snackPosition: SnackPosition.BOTTOM,
          );
          return null; // Don't throw exception here
        }
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Registration Failed',
        e.toString(),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null; // Don't throw exception here
    }
    return null;
  }

  // Logout Function
  Future<void> logout() async {
    await Pref.clearAuthData(); // Clear local data
  }
}
