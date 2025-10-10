// lib/modules/manage_practice/problems/manage_problems_binding.dart

import 'package:get/get.dart';
import 'manage_problems_controller.dart';

class ManageProblemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageProblemsController>(() => ManageProblemsController());
  }
}