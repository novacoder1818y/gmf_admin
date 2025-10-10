// lib/data/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime joinedDate;
  final int xp;
  final int streak;
  final bool isSuspended; // <-- ADDED THIS BACK

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.joinedDate,
    required this.xp,
    this.streak = 0,
    this.isSuspended = false, // <-- ADDED THIS BACK
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? 'No Name',
      email: data['email'] ?? 'No Email',
      joinedDate: (data['joinedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      xp: data['xp'] ?? 0,
      streak: data['streak'] ?? 0,
      isSuspended: data['isSuspended'] ?? false, // <-- ADDED THIS BACK
    );
  }
}