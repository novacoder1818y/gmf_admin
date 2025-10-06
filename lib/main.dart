import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/controllers/theme_controller.dart';
import 'app/routes/admin_pages.dart';
import 'app/theme/app_theme.dart';

void main() {
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