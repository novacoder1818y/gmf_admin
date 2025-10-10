// lib/modules/main/admin_main_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/admin_pages.dart';
import '../../routes/admin_routes.dart';
import 'admin_drawer.dart';
import 'admin_main_controller.dart';

class AdminMainView extends GetView<AdminMainController> {
  const AdminMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.pageTitle.value)),
      ),
      drawer: const AdminDrawer(),
      body: Navigator(
        key: Get.nestedKey(1), // A unique key for this navigator
        initialRoute: Routes.DASHBOARD,
        onGenerateRoute: (settings) {
          final page = AdminPages.routes.firstWhere(
                (p) => p.name == settings.name,
            orElse: () => AdminPages.routes.first,
          );
          return GetPageRoute(
            settings: settings,
            page: page.page,
            binding: page.binding,
          );
        },
      ),
    );
  }
}