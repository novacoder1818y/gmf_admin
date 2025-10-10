// lib/modules/users/user_detail_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:gmfc_admin/app/modules/users/user_admin_controller.dart';
import 'package:intl/intl.dart';
import '../../data/models/user_model.dart';
import '../../widgets/neon_button.dart';

class UserDetailView extends StatelessWidget {
  const UserDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final UsersAdminController usersController = Get.find();
    // Get the initial (static) user data from arguments
    final UserModel initialUser = Get.arguments;

    // THIS IS THE FIX: Find the REAL, REACTIVE user object from the controller's list.
    final Rx<UserModel> user = usersController.filteredUsers
        .firstWhere((u) => u.id == initialUser.id, orElse: () => initialUser)
        .obs;

    return Scaffold(
      appBar: AppBar(title: Text(initialUser.name)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            // Wrap the Stack in an Obx to update the suspend icon in real-time
            child: Obx(
                  () => Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(radius: 60, child: Icon(Icons.person, size: 60)),
                  if (user.value.isSuspended)
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.block, color: Colors.white),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailCard(context, 'User Details', [
            _buildDetailRow('Name', initialUser.name),
            _buildDetailRow('Email', initialUser.email),
            _buildDetailRow('Joined Date', DateFormat.yMMMd().format(initialUser.joinedDate)),
          ]).animate().fadeIn(delay: 200.ms).slideX(),
          const SizedBox(height: 20),
          _buildDetailCard(context, 'Gamification Stats', [
            _buildDetailRow('XP Points', initialUser.xp.toString()),
            _buildDetailRow('Streak', '${initialUser.streak} days'),
          ]).animate().fadeIn(delay: 400.ms).slideX(),
          const SizedBox(height: 30),
          Text('Admin Actions', style: Theme.of(context).textTheme.headlineSmall)
              .animate().fadeIn(delay: 600.ms),
          const SizedBox(height: 16),
          // Wrap the button in an Obx to update its text, color, and action in real-time
          Obx(
                () => NeonButton(
              text: user.value.isSuspended ? 'Unsuspend User' : 'Suspend User',
              onTap: () {
                if (user.value.isSuspended) {
                  usersController.unsuspendUser(user.value);
                  Navigator.pop(context);
                } else {
                  usersController.suspendUser(user.value);
                  Navigator.pop(context);
                }
              },
              gradientColors: user.value.isSuspended
                  ? [Colors.green, Colors.teal]
                  : [Colors.orange, Colors.deepOrange],
            ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
      BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
              )),
        ],
      ),
    );
  }
}