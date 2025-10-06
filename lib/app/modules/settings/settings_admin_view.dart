import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';
import '../../routes/admin_routes.dart';

class SettingsAdminView extends StatelessWidget {
  const SettingsAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
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
              Get.offAllNamed(Routes.AUTH);
            },
          ).animate().fadeIn(delay: 200.ms).slideX(),
        ],
      ),
    );
  }
}