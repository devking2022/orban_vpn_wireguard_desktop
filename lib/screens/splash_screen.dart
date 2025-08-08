import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../widgets/background_widget.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth(); // Check authentication status on start
  }

  // Check user authentication and navigate accordingly
  void _checkAuth() async {
    // Wait for Pref initialization, if needed
    await Future.delayed(const Duration(milliseconds: 1500));

    // Check if the user has seen the intro screen
    // if (Pref.isIntro == false) {
    //   Get.off(IntroducationScreen());
    //   return;
    // }

    // User is authenticated, navigate to Home Screen
    Get.off(const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          background_widget(assets: 'assets/images/0.png', full: true),
          //app logo
          Center(
              child: Image.asset(
            'assets/images/logo.png',
            width: Get.width / 4,
          )),
        ],
      ),
    );
  }
}
