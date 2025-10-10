// lib/modules/active_users/active_users_binding.dart

import 'package:get/get.dart';
import 'active_users_controller.dart';

class ActiveUsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActiveUsersController>(() => ActiveUsersController());
  }
}