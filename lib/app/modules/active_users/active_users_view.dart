// lib/modules/active_users/active_users_view.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../routes/admin_pages.dart';
import 'active_users_controller.dart';

class ActiveUsersView extends GetView<ActiveUsersController> {
  const ActiveUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(title: const Text('Daily Active Users')),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getActiveUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users have been active in the last 24 hours.'));
          }
          final activeUsers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: activeUsers.length,
            itemBuilder: (context, index) {
              final user = activeUsers[index].data() as Map<String, dynamic>;
              final Timestamp? lastLogin = user['lastLogin'] as Timestamp?;
              final String lastLoginTime = lastLogin != null
                  ? DateFormat('hh:mm a').format(lastLogin.toDate())
                  : 'N/A';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user['name'] ?? 'No Name'),
                  subtitle: Text(user['email'] ?? 'No Email'),
                  trailing: Text('Last seen: $lastLoginTime'),
                  onTap: () {
                    // Navigate to the user's public profile
                    // You would need a PublicProfileView in your admin app for this.
                    // For now, let's navigate to the existing UserDetailView.
                    // NOTE: You must create a UserModel instance to pass here.
                    // Get.toNamed(Routes.USER_DETAIL, arguments: UserModel.fromMap(user));

                    // Simplified navigation if UserDetailView can handle a map:
                    Get.snackbar('Info', 'Navigate to user detail for ${user['name']}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}