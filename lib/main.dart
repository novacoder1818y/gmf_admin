import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmfc_admin/firebase_options.dart';
import 'app/controllers/theme_controller.dart';
import 'app/routes/admin_pages.dart';
import 'app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  // Initialize and register the ThemeController for app-wide use.
  Get.put(ThemeController());
  runApp(const AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the globally available ThemeController.
    final ThemeController themeController = Get.find();

    // Obx makes this widget reactive to changes in themeController.isDarkMode.
    return Obx(
          () => GetMaterialApp(
        title: 'Gamified Coding Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // Set the light theme
        darkTheme: AppTheme.darkTheme, // Set the dark theme
        themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        initialRoute: AdminPages.INITIAL, // Start at the auth screen
        getPages: AdminPages.routes,
      ),
    );
  }
}