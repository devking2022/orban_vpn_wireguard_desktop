import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import '../controllers/home_controller.dart';
import '../helpers/pref.dart';
import '../services/vpn_engine.dart';

class SystemTrayService extends GetxService with TrayListener {
  static SystemTrayService get to => Get.find();
  
  HomeController? _homeController;
  bool _isInitialized = false;
  
  HomeController? get homeController => _homeController;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize tray immediately
    _initTray();
  }

  Future<void> _initTray() async {
    try {
      debugPrint('Initializing system tray...');
      
      // First, set up the tray icon
      await _setTrayIcon();
      
      // Then set up the tray menu
      await _updateTrayMenu();
      
      // Listen to tray events
      trayManager.addListener(this);
      
      _isInitialized = true;
      debugPrint('System tray initialized successfully');
      
    } catch (e) {
      debugPrint('Failed to initialize system tray: $e');
    }
  }

  Future<void> _setTrayIcon() async {
    try {
      debugPrint('Setting tray icon...');
      
      // For Windows, use the ICO files
      String iconPath = 'assets/images/vpn_off.ico';
      
      if (_homeController != null && _homeController!.vpnState.value == VpnEngine.vpnConnected) {
        iconPath = 'assets/images/vpn_on.ico';
        debugPrint('VPN is connected, using vpn_on.ico');
      } else {
        debugPrint('VPN is disconnected, using vpn_off.ico');
      }
      
      debugPrint('Setting tray icon with: $iconPath');
      
      await trayManager.setIcon(
        iconPath,
        isTemplate: false,
      );
      
      debugPrint('Tray icon set successfully');
      
    } catch (e) {
      debugPrint('Failed to set tray icon: $e');
      
      // Try fallback
      try {
        debugPrint('Trying fallback icon...');
        await trayManager.setIcon(
          'assets/images/logo.png',
          isTemplate: false,
        );
        debugPrint('Fallback icon set successfully');
      } catch (e2) {
        debugPrint('Fallback icon also failed: $e2');
      }
    }
  }

  Future<void> _updateTrayMenu() async {
    try {
      // Try to get HomeController if not already available
      if (_homeController == null) {
        try {
          _homeController = Get.find<HomeController>();
        } catch (e) {
          debugPrint('HomeController not available yet: $e');
          return;
        }
      }

      final isConnected = _homeController!.vpnState.value == VpnEngine.vpnConnected;
      
      debugPrint('Updating tray menu - VPN connected: $isConnected');
      
      final menu = Menu(
        items: [
          MenuItem(
            key: 'status',
            label: isConnected ? 'Connected' : 'Disconnected',
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'toggle_connection',
            label: isConnected ? 'Disconnect' : 'Connect',
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'show_app',
            label: 'Show App',
          ),
          MenuItem(
            key: 'settings',
            label: 'Settings',
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'quit',
            label: 'Quit',
          ),
        ],
      );
      
      await trayManager.setContextMenu(menu);
      debugPrint('Tray menu updated successfully');
      
    } catch (e) {
      debugPrint('Failed to update tray menu: $e');
    }
  }

  @override
  void onTrayIconMouseDown() {
    debugPrint('Tray icon left clicked');
    // Show context menu on left click
    try {
      trayManager.popUpContextMenu();
      debugPrint('Context menu shown on left click');
    } catch (e) {
      debugPrint('Failed to show context menu on left click: $e');
    }
  }

  @override
  void onTrayIconRightMouseDown() {
    debugPrint('Tray icon right clicked');
    // Show context menu on right click
    try {
      trayManager.popUpContextMenu();
      debugPrint('Context menu shown on right click');
    } catch (e) {
      debugPrint('Failed to show context menu on right click: $e');
    }
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    debugPrint('Tray menu item clicked: ${menuItem.key}');
    
    switch (menuItem.key) {
      case 'toggle_connection':
        debugPrint('Toggle connection clicked');
        _toggleConnection();
        break;
      case 'show_app':
        debugPrint('Show app clicked');
        _showApp();
        break;
      case 'settings':
        debugPrint('Settings clicked');
        _openSettings();
        break;
      case 'quit':
        debugPrint('Quit clicked');
        _quitApp();
        break;
      default:
        debugPrint('Unknown menu item clicked: ${menuItem.key}');
    }
  }

  Future<void> _toggleConnection() async {
    if (_homeController == null) {
      try {
        _homeController = Get.find<HomeController>();
      } catch (e) {
        debugPrint('HomeController not available for toggle: $e');
        return;
      }
    }

    if (_homeController!.vpnState.value == VpnEngine.vpnConnected) {
      _homeController!.disConnect();
    } else {
      // Connect using the current VPN configuration
      _homeController!.connectToVpn(vpnModel: Pref.vpn);
    }
    
    // Update tray menu after state change
    await Future.delayed(const Duration(milliseconds: 500));
    await updateTrayMenu();
  }

  Future<void> _showApp() async {
    // Show the main window
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> _openSettings() async {
    // Navigate to settings screen
    try {
      Get.toNamed('/setting_screen');
    } catch (e) {
      // If route not found, show the app first
      await _showApp();
    }
  }

  Future<void> _quitApp() async {
    // Disconnect VPN if connected
    if (_homeController != null && _homeController!.vpnState.value == VpnEngine.vpnConnected) {
      _homeController!.disConnect();
    }
    
    // Exit the application
    exit(0);
  }

  Future<void> updateTrayMenu() async {
    if (_isInitialized) {
      await _updateTrayMenu();
      await _setTrayIcon(); // Update icon based on current state
    }
  }

  @override
  void onClose() {
    trayManager.removeListener(this);
    super.onClose();
  }
} 