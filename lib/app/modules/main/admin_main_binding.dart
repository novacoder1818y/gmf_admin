// lib/modules/main/admin_main_binding.dart

import 'package:get/get.dart';
import 'admin_main_controller.dart';

class AdminMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminMainController>(() => AdminMainController());
  }
}