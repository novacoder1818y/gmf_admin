// lib/modules/challenges/challenges_admin_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../routes/admin_routes.dart';
import 'challenges_controller.dart';

class ChallengesAdminView extends GetView<ChallengesController> {
  const ChallengesAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // THE APPBAR HAS BEEN REMOVED FROM THIS PAGE
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.ADD_CHALLENGE),
        label: const Text('Add Challenge'),
        icon: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) => controller.filterChallenges(query),
              decoration: InputDecoration(
                labelText: 'Search challenges...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: Obx(
                  () => ListView.builder(
                itemCount: controller.filteredChallenges.length,
                itemBuilder: (context, index) {
                  final challenge = controller.filteredChallenges[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.code),
                      title: Text(challenge.title),
                      subtitle: Text('Difficulty: ${challenge.difficulty} | Points: ${challenge.points}'),
                      onTap: () => Get.toNamed(Routes.CHALLENGE_DETAIL, arguments: challenge),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => Get.toNamed(Routes.ADD_CHALLENGE, arguments: challenge),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20, color: Colors.redAccent),
                            onPressed: () => controller.deleteChallenge(challenge),
                          ),
                        ],
                      ),
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