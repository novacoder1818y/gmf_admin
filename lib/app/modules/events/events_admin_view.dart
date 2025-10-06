import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/dummy_data.dart';
import '../../data/models/event_model.dart';
import '../../routes/admin_routes.dart';

class EventsAdminView extends StatefulWidget {
  const EventsAdminView({super.key});

  @override
  State<EventsAdminView> createState() => _EventsAdminViewState();
}

class _EventsAdminViewState extends State<EventsAdminView> {
  late List<EventModel> _filteredEvents;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _filteredEvents = DummyData.events;
    });
  }

  void _filterEvents(String query) {
    final filtered = DummyData.events.where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() => _filteredEvents = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Management')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterEvents,
              decoration: InputDecoration(
                labelText: 'Search events...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredEvents.length,
              itemBuilder: (context, index) {
                final event = _filteredEvents[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.event),
                    title: Text(event.title),
                    subtitle: Text(
                        '${DateFormat.yMMMd().format(event.startDate)} - ${DateFormat.yMMMd().format(event.endDate)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () {}),
                        IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.redAccent), onPressed: () {}),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.5);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.ADD_EVENT)?.then((_) => _refreshList()),
        label: const Text('Add Event'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}