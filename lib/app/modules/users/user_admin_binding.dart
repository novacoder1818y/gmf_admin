// lib/modules/users/users_admin_binding.dart

import 'package:get/get.dart';
import 'package:gmfc_admin/app/modules/users/user_admin_controller.dart';

class UsersAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersAdminController>(() => UsersAdminController());
  }
}