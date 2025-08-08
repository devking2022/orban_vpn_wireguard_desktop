import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

import 'controllers/laungage_controller.dart';
import 'helpers/config.dart';
import 'helpers/constants.dart';
import 'helpers/pref.dart';
import 'screens/splash_screen.dart';
import 'services/admin_permission_service.dart';
import 'services/system_tray_service.dart';
import 'services/window_manager_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive first
  await Pref.initializeHive();

  // Initialize window manager
  await windowManager.ensureInitialized();
  
  // Set window options
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 650),
    maximumSize: Size(800, 650),
    minimumSize: Size(800, 650),
    center: true,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    // Check if app was previously minimized
    if (Pref.wasMinimizedOnClose) {
      // Start minimized in system tray
      await windowManager.hide();
    } else {
      // Show window normally
    await windowManager.show();
      await windowManager.focus();
    }
  });

  // Initialize services
  await Future.wait([
    Get.putAsync(() async => AdminPermissionService()),
    Get.putAsync(() async => WindowManagerService()),
  ]);

  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Config.appName,
      home: const SplashScreen(),

      themeMode: ThemeMode.dark,

      //dark theme
      darkTheme: ThemeData(
          scaffoldBackgroundColor: background,
          useMaterial3: false,
          brightness: Brightness.dark,
          fontFamily: 'Montserrat',
          appBarTheme: const AppBarTheme(elevation: 0)),
      debugShowCheckedModeBanner: false,

      translations: AppTranslations(),
      locale: Locale(Pref.lan),
      fallbackLocale: Locale(Pref.lan),
    );
  }
}
