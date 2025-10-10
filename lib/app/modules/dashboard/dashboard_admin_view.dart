// lib/modules/dashboard/dashboard_admin_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../routes/admin_routes.dart';
import '../../widgets/stat_card.dart';
import '../main/admin_main_controller.dart';
import 'dashboard_admin_controller.dart';

class DashboardAdminView extends GetView<DashboardAdminController> {
  const DashboardAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    // We find the AdminMainController to control the page changes.
    final AdminMainController mainController = Get.find();

    // The list of stat card configurations with corrected onTap actions.
    final statCardsConfig = [
      {
        'stream': controller.getTotalUsersStream(),
        'title': 'Total Users',
        'icon': Icons.group,
        'color': Colors.blue,
        // THIS IS THE FIX: Call changePage with the correct index (3 for Users)
        'onTap': () => mainController.changePage(3),
      },
      {
        'stream': controller.getTotalChallengesStream(),
        'title': 'Challenges',
        'icon': Icons.gamepad,
        'color': Colors.green,
        // THIS IS THE FIX: Call changePage with the correct index (1 for Challenges)
        'onTap': () => mainController.changePage(1),
      },
      {
        'stream': controller.getActiveEventsStream(),
        'title': 'Active Events',
        'icon': Icons.event,
        'color': Colors.purple,
        // THIS IS THE FIX: Call changePage with the correct index (2 for Events)
        'onTap': () => mainController.changePage(2),
      },
      {
        'stream': controller.getDailyActiveUsersStream(),
        'title': 'Daily Active',
        'icon': Icons.local_fire_department,
        'color': Colors.orange,
        // This navigation is correct because ACTIVE_USERS is a separate page, not in the drawer.
        'onTap': () => Get.toNamed(Routes.ACTIVE_USERS),
      },
    ];

    return Scaffold(
      // No AppBar here, as it's handled by AdminMainView
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
              itemCount: statCardsConfig.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final cardConfig = statCardsConfig[index];

                return _buildLiveStatCard(
                  stream: cardConfig['stream'] as Stream<int>,
                  title: cardConfig['title'] as String,
                  icon: cardConfig['icon'] as IconData,
                  color: cardConfig['color'] as Color,
                  onTap: cardConfig['onTap'] as VoidCallback,
                )
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

  Widget _buildLiveStatCard({
    required Stream<int> stream,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return StreamBuilder<int>(
      stream: stream,
      builder: (context, snapshot) {
        return StatCard(
          title: title,
          value: snapshot.hasData ? snapshot.data.toString() : '...',
          icon: icon,
          color: color,
          onTap: onTap,
        );
      },
    );
  }
}