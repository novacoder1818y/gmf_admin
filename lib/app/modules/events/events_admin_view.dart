import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../routes/admin_routes.dart';
import 'events_admin_controller.dart';

class EventsAdminView extends GetView<EventsAdminController> {
  const EventsAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  appBar: AppBar(title: const Text('Event Management')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').orderBy('startDate', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No events found. Create one!'));
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final data = event.data() as Map<String, dynamic>;
              final DateTime startDate = (data['startDate'] as Timestamp).toDate();

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.event_note),
                  title: Text(data['title']),
                  subtitle: Text('Starts: ${DateFormat.yMMMd().add_jm().format(startDate)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit Button now navigates to the form with event data
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => Get.toNamed(Routes.ADD_EVENT, arguments: event),
                      ),
                      // Delete Button now calls the controller method
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.redAccent),
                        onPressed: () => controller.deleteEvent(event.id, data['title']),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.5);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.ADD_EVENT),
        label: const Text('Add Event'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}