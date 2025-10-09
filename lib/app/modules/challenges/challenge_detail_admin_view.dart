import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/challenge_model.dart';
import '../../routes/admin_routes.dart';
import 'challenges_controller.dart';

class ChallengeDetailAdminView extends GetView<ChallengesController> {
  const ChallengeDetailAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final ChallengeModel challenge = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(challenge.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            tooltip: 'Edit Challenge',
            onPressed: () => Get.toNamed(Routes.ADD_CHALLENGE, arguments: challenge),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
            tooltip: 'Delete Challenge',
            onPressed: () => controller.deleteChallenge(challenge),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDetailCard(context, 'Challenge Details', [
            _buildDetailRow('Title', challenge.title),
            _buildDetailRow('Category', challenge.category),
            _buildDetailRow('Difficulty', challenge.difficulty),
            _buildDetailRow('XP Points', challenge.points.toString()),
          ]),
          const SizedBox(height: 16),
          // This now correctly checks for the new fields in the ChallengeModel
          if(challenge.questionType == 'multiple_choice')
            _buildDetailCard(context, 'Question & Answer', [
              Text(challenge.description, style: const TextStyle(fontSize: 16)),
              const Divider(height: 20),
              if(challenge.options != null)
                ...challenge.options!.map((option) => ListTile(
                  leading: Icon(
                    option == challenge.correctAnswer ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: option == challenge.correctAnswer ? Colors.greenAccent : null,
                  ),
                  title: Text(option),
                )),
            ]),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, String title, List<Widget> children) {
    return Card(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}