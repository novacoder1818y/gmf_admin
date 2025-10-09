// settings_admin_binding.dart

import 'package:get/get.dart';
import 'package:gmfc_admin/app/modules/settings/setting_admin_controller.dart';

class SettingsAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsAdminController>(() => SettingsAdminController());
  }
}