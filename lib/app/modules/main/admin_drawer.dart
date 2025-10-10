// lib/modules/main/admin_drawer.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_main_controller.dart';

class AdminDrawer extends GetView<AdminMainController> {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Content Management', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          _buildDrawerItem(icon: Icons.dashboard, title: 'Dashboard', index: 0),
          _buildDrawerItem(icon: Icons.article, title: 'Code Feed', index: 1),
          _buildDrawerItem(icon: Icons.gamepad, title: 'Challenges', index: 2),
          _buildDrawerItem(icon: Icons.event, title: 'Events', index: 3),
          _buildDrawerItem(icon: Icons.fitness_center, title: 'Practice Arena', index: 5),

          _buildDrawerItem(icon: Icons.group, title: 'Users', index: 4),
          const Divider(),
          _buildDrawerItem(icon: Icons.settings, title: 'Settings', index: 6),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    return Obx(
          () => ListTile(
        leading: Icon(icon),
        title: Text(title),
        selected: controller.selectedIndex.value == index,
        selectedTileColor: Colors.blueAccent.withOpacity(0.1),
        onTap: () => controller.changePage(index),
      ),
    );
  }
}