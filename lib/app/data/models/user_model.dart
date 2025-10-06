class UserModel {
  final String id;
  final String name;
  final String email;
  final int xp;
  final int streak;
  final DateTime joinedDate;
  bool isSuspended;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.xp,
    required this.streak,
    required this.joinedDate,
    this.isSuspended = false,
  });
}