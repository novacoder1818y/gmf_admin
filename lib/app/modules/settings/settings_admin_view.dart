// settings_admin_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:gmfc_admin/app/modules/settings/setting_admin_controller.dart';
import '../../controllers/theme_controller.dart';

class SettingsAdminView extends StatelessWidget {
  const SettingsAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the globally available ThemeController
    final ThemeController themeController = Get.find();
    final SettingsAdminController controller = Get.put(SettingsAdminController());

    return Scaffold(
      // appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Obx(
                () => SwitchListTile(
              title: const Text('Dark Mode'),
              secondary: const Icon(Icons.brightness_6_outlined),
              value: themeController.isDarkMode.value,
              onChanged: (value) {
                themeController.toggleTheme();
              },
            ),
          ).animate().fadeIn().slideX(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Log Out'),
            onTap: () {
              // Call the confirmation method from the controller
              controller.confirmLogout();
            },
          ).animate().fadeIn(delay: 200.ms).slideX(),
        ],
      ),
    );
  }
}