// lib/modules/dashboard/dashboard_admin_binding.dart

import 'package:get/get.dart';
import 'dashboard_admin_controller.dart';

class DashboardAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardAdminController>(() => DashboardAdminController());
  }
}