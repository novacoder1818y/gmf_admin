import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Manages the application's theme (light/dark mode).
class ThemeController extends GetxController {
  // .obs makes this variable reactive.
  var isDarkMode = true.obs;

  // Method to toggle the theme and update the GetX theme mode.
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}