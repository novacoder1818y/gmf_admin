import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../data/dummy_data.dart';
import '../../data/models/challenge_model.dart';
import '../../routes/admin_routes.dart';

class ChallengesAdminView extends StatefulWidget {
  const ChallengesAdminView({super.key});

  @override
  State<ChallengesAdminView> createState() => _ChallengesAdminViewState();
}

class _ChallengesAdminViewState extends State<ChallengesAdminView> {
  late List<ChallengeModel> _filteredChallenges;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  // This method reloads the list from the source of truth.
  void _refreshList() {
    setState(() {
      _filteredChallenges = DummyData.challenges;
    });
  }

  void _filterChallenges(String query) {
    final filtered = DummyData.challenges.where((challenge) {
      return challenge.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() => _filteredChallenges = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Challenge Management')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterChallenges,
              decoration: InputDecoration(
                labelText: 'Search challenges...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredChallenges.length,
              itemBuilder: (context, index) {
                final challenge = _filteredChallenges[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.code),
                    title: Text(challenge.title),
                    subtitle: Text('Difficulty: ${challenge.difficulty} | Points: ${challenge.points}'),
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
        // THIS IS THE FIX:
        // When we navigate to the form, we wait for it to close (`.then`).
        // Once it's closed, we call `_refreshList()` to rebuild the UI with the new data.
        onPressed: () => Get.toNamed(Routes.ADD_CHALLENGE)?.then((_) => _refreshList()),
        label: const Text('Add Challenge'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}