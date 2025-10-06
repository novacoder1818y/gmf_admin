import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/user_model.dart';
import '../../widgets/neon_button.dart';

class UserDetailView extends StatelessWidget {
  const UserDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = Get.arguments;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(radius: 60, child: Icon(Icons.person, size: 60)),
                if (user.isSuspended)
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.block, color: Colors.white),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailCard(context, 'User Details', [
            _buildDetailRow('Name', user.name),
            _buildDetailRow('Email', user.email),
            _buildDetailRow('Joined Date', DateFormat.yMMMd().format(user.joinedDate)),
          ]).animate().fadeIn(delay: 200.ms).slideX(),
          const SizedBox(height: 20),
          _buildDetailCard(context, 'Gamification Stats', [
            _buildDetailRow('XP Points', user.xp.toString()),
            _buildDetailRow('Current Streak', '${user.streak} days'),
          ]).animate().fadeIn(delay: 400.ms).slideX(),
          const SizedBox(height: 30),
          Text('Admin Actions', style: Theme.of(context).textTheme.headlineSmall)
              .animate().fadeIn(delay: 600.ms),
          const SizedBox(height: 16),
          NeonButton(
            text: user.isSuspended ? 'Unsuspend User' : 'Suspend User',
            onTap: () {
              Get.snackbar('Action Successful',
                '${user.name} has been ${user.isSuspended ? "unsuspended" : "suspended"}.',
                backgroundColor: isDark ? Colors.green : Colors.black,
                colorText: Colors.white,
              );
            },
            gradientColors: user.isSuspended
                ? [Colors.green, Colors.teal]
                : [Colors.orange, Colors.deepOrange],
          ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.5),
          const SizedBox(height: 16),
          NeonButton(
            text: 'Delete User',
            onTap: () {
              Get.defaultDialog(
                  title: "Confirm Deletion",
                  middleText: "Are you sure you want to delete ${user.name}?",
                  textConfirm: "Delete",
                  textCancel: "Cancel",
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    Get.back();
                    Get.back();
                    Get.snackbar('Action Successful', '${user.name} has been deleted.');
                  });
            },
            gradientColors: const [Colors.red, Colors.pinkAccent],
          ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.5),
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