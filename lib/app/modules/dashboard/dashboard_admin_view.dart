import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../widgets/stat_card.dart';
import '../main/admin_main_controller.dart';

class DashboardAdminView extends StatelessWidget {
  const DashboardAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminMainController mainController = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final statCards = [
                  StatCard(title: 'Total Users', value: '3', icon: Icons.group, color: Colors.blue, onTap: () => mainController.changePage(3)),
                  StatCard(title: 'Challenges', value: '2', icon: Icons.gamepad, color: Colors.green, onTap: () => mainController.changePage(1)),
                  StatCard(title: 'Active Events', value: '3', icon: Icons.event, color: Colors.purple, onTap: () => mainController.changePage(2)),
                  StatCard(title: 'Daily Active', value: '2', icon: Icons.local_fire_department, color: Colors.orange, onTap: () {}),
                ];
                return statCards[index]
                    .animate()
                    .fadeIn(delay: (100 * index).ms)
                    .slideX(begin: -0.2);
              },
            ),
            const SizedBox(height: 30),
            Text("Recent Activity", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 15),
            Card(
              child: const ListTile(
                leading: Icon(Icons.person_add),
                title: Text("New user 'CodeNinja' registered."),
                subtitle: Text("5 minutes ago"),
              ),
            ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.2),
            Card(
              child: const ListTile(
                leading: Icon(Icons.add_circle),
                title: Text("New challenge 'Recursive Thinking' was added."),
                subtitle: Text("1 hour ago"),
              ),
            ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.2),
          ],
        ),
      ),
    );
  }
}