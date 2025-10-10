// lib/modules/users/users_admin_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:gmfc_admin/app/modules/users/user_admin_controller.dart';
import '../../routes/admin_routes.dart';

class UsersAdminView extends GetView<UsersAdminController> {
  const UsersAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('User Management')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) => controller.filterUsers(query),
              decoration: InputDecoration(
                labelText: 'Search by name or email...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: Obx(
                  () => ListView.builder(
                itemCount: controller.filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = controller.filteredUsers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      // SHOWS AN ICON IF THE USER IS SUSPENDED
                      trailing: user.isSuspended ? const Icon(Icons.block, color: Colors.red) : null,
                      onTap: () => Get.toNamed(Routes.USER_DETAIL, arguments: user),
                    ),
                  ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.5);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}