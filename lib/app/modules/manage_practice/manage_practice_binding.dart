// lib/modules/manage_practice/manage_practice_binding.dart

import 'package:get/get.dart';
import 'manage_practice_controller.dart';

class ManagePracticeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagePracticeController>(() => ManagePracticeController());
  }
}