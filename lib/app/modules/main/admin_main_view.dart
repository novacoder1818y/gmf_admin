import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_main_controller.dart';

class AdminMainView extends GetView<AdminMainController> {
  const AdminMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile View
          return Scaffold(
            body: Obx(() => controller.pages[controller.selectedIndex.value]),
            bottomNavigationBar: Obx(
                  () => BottomNavigationBar(
                currentIndex: controller.selectedIndex.value,
                onTap: controller.changePage,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
                  BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: 'Challenges'),
                  BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
                  BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Users'),
                  BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
                ],
              ),
            ),
          );
        } else {
          // Desktop View
          return Scaffold(
            body: Row(
              children: [
                Obx(
                      () => NavigationRail(
                    selectedIndex: controller.selectedIndex.value,
                    onDestinationSelected: controller.changePage,
                    labelType: NavigationRailLabelType.all,
                    destinations: const [
                      NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
                      NavigationRailDestination(icon: Icon(Icons.gamepad), label: Text('Challenges')),
                      NavigationRailDestination(icon: Icon(Icons.event), label: Text('Events')),
                      NavigationRailDestination(icon: Icon(Icons.group), label: Text('Users')),
                      NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Settings')),
                    ],
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: Obx(() => controller.pages[controller.selectedIndex.value]),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}