import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class ChallengeListItem extends StatelessWidget {
  final String title;
  final String category;
  final String difficulty;

  const ChallengeListItem({
    super.key,
    required this.title,
    required this.category,
    required this.difficulty,
  });

  Color _getDifficultyColor() {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.greenAccent;
      case 'medium':
        return Colors.orangeAccent;
      case 'hard':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(category, style: TextStyle(color: AppTheme.primaryColor)),
                      const Text(" • "),
                      Text(difficulty, style: TextStyle(color: _getDifficultyColor())),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.white70),
              onPressed: () {
                // TODO: Implement edit functionality
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () {
                // TODO: Implement delete functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
