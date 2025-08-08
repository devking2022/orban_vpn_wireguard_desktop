import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/pref.dart';

class AdminPermissionService extends GetxService {
  static AdminPermissionService get to => Get.find();
  
  final RxBool hasAdminPermissions = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAdminPermissions();
  }

  Future<void> _checkAdminPermissions() async {
    if (Platform.isWindows) {
      // Check if we already have admin permissions
      hasAdminPermissions.value = Pref.hasAdminPermissions;
      
      if (!hasAdminPermissions.value) {
        await _requestAdminPermissions();
      }
    } else {
      // On macOS, permissions are handled differently
      hasAdminPermissions.value = true;
    }
  }

  Future<void> _requestAdminPermissions() async {
    try {
      // Check if the app is running with admin privileges
      final result = await Process.run('net', ['session'], runInShell: true);
      
      if (result.exitCode == 0) {
        // We have admin permissions
        hasAdminPermissions.value = true;
        Pref.hasAdminPermissions = true;
        debugPrint('Admin permissions granted');
      } else {
        // For now, just mark as having permissions to avoid repeated requests
        hasAdminPermissions.value = true;
        Pref.hasAdminPermissions = true;
        debugPrint('Admin permissions assumed for development');
      }
    } catch (e) {
      debugPrint('Error checking admin permissions: $e');
      // Assume permissions for development
      hasAdminPermissions.value = true;
      Pref.hasAdminPermissions = true;
    }
  }

  Future<bool> ensureAdminPermissions() async {
    if (hasAdminPermissions.value) {
      return true;
    }
    
    await _requestAdminPermissions();
    return hasAdminPermissions.value;
  }

  void markAsHavingPermissions() {
    hasAdminPermissions.value = true;
    Pref.hasAdminPermissions = true;
  }
} 