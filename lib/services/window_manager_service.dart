import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import '../helpers/pref.dart';

class WindowManagerService extends GetxService with WindowListener {
  static WindowManagerService get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    // Listen to window events
    windowManager.addListener(this);
  }

  @override
  void onWindowClose() async {
    // Save the current minimized state
    final isMinimized = await windowManager.isMinimized();
    Pref.wasMinimizedOnClose = isMinimized;
    
    // Hide window instead of closing
    await windowManager.hide();
  }

  @override
  void onClose() {
    windowManager.removeListener(this);
    super.onClose();
  }
} 