// lib/modules/main/admin_main_controller.dart

import 'package:get/get.dart';
import '../../routes/admin_routes.dart';

class AdminMainController extends GetxController {
  var selectedIndex = 0.obs;
  var pageTitle = 'Admin Dashboard'.obs;

  // A list of the route names for each page in the drawer
  final List<String> pageRoutes = [
    Routes.DASHBOARD,
    Routes.FEED,
    Routes.CHALLENGES,
    Routes.EVENTS,
    Routes.USERS,
    Routes.MANAGE_PRACTICE,
    Routes.SETTINGS,
  ];

  // A list of titles corresponding to the pages
  final List<String> titles = [
    'Admin Dashboard',
    'Code Feed Management', // <-- ADDED TITLE
    'Challenge Management',
    'Event Management',
    'User Management',
    'Practice Arena',
    'Settings',
  ];

  /// Changes the page in the nested navigator and updates the AppBar title.
  void changePage(int index) {
    if (selectedIndex.value == index) {
      Get.back(); // Just close the drawer
      return;
    }

    selectedIndex.value = index;
    pageTitle.value = titles[index];

    Get.toNamed(
      pageRoutes[index],
      id: 1, // The ID of our nested navigator
    );
    Get.back(); // Close the drawer after selection
  }
}