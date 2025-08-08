import 'dart:async';

import 'package:get/get.dart';
import '../models/user_model.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var user = UserModel(id: "0").obs;
  final AuthService _authService = AuthService();

  // Forgot Password
  RxBool isOtpSent = false.obs;
  RxInt otpTimer = 60.obs;
  RxBool obscurePassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;

  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;
    try {
      final loggedInUser = await _authService.login(email, password);
      if (loggedInUser != null) {
        user.value = loggedInUser;

        Get.offAll(const SplashScreen()); // Navigate to Home Page
      } else {
        Get.snackbar('Error', 'Login Failed');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
      {required String email,
      required String password,
      required String confirmPassword,
      required String name}) async {
    isLoading.value = true;
    try {
      final registeredUser = await _authService.register(
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          name: name);
      if (registeredUser != null) {
        user.value = registeredUser;
        Get.offAll(const HomeScreen()); // Navigate to Home Page
      } else {
        Get.snackbar('Error', 'Registration Failed');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendOtp({required String email}) async {
    isLoading.value = true;
    try {
      final response = await _authService.forgotSendOTP(email: email);
      print(response);
      if (response != null && response['type'] == 'success') {
        isOtpSent.value = true;
        startOtpTimer();
        Get.snackbar(
          'Success',
          'OTP sent successfully',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to send OTP',
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotAccount({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authService.forgotAccount(
        email: email,
        otp: otp,
        password: password,
        confirmPassword: confirmPassword,
      );
      print(response);
      if (response != null && response['type'] == 'success') {
        Get.back(); // Go back to the previous screen
        Get.snackbar(
          'Success',
          'Password reset successfully',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to reset password',
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAll(const HomeScreen()); // Navigate back to Login
  }

  void startOtpTimer() {
    otpTimer.value = 60; // Set timer to 60 seconds
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimer.value > 0) {
        otpTimer.value--;
      } else {
        timer.cancel();
        isOtpSent.value = false;
      }
      update();
    });
  }
}
