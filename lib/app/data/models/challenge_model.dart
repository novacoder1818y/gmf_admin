import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final String category;
  final int points;
  final String? questionType;
  final List<String>? options;
  final String? correctAnswer;

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.category,
    required this.points,
    this.questionType,
    this.options,
    this.correctAnswer,
  });

  // Factory constructor to create a ChallengeModel from a Firestore document.
  // This fixes the 'fromFirestore isn't defined' error.
  factory ChallengeModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChallengeModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      difficulty: data['difficulty'] ?? 'Easy',
      category: data['category'] ?? 'Coding',
      points: data['points'] ?? 0,
      questionType: data['questionType'],
      options: data['options'] != null ? List<String>.from(data['options']) : null,
      correctAnswer: data['correctAnswer'],
    );
  }
}

