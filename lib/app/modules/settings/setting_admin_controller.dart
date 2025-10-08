// settings_admin_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/auth_controller.dart';

class SettingsAdminController extends GetxController {
  final AuthController _authController = Get.find();

  // Method to show a confirmation dialog before logging out
  void confirmLogout() {
    Get.defaultDialog(
      title: "Confirm Logout",
      middleText: "Are you sure you want to log out?",
      textConfirm: "Logout",
      confirmTextColor: Colors.white,
      textCancel: "Cancel",
      onConfirm: () {
        // Call the central logout method from AuthController
        _authController.logout();
      },
      // You can customize colors to match your theme
      // buttonColor: Colors.redAccent,
    );
  }
}