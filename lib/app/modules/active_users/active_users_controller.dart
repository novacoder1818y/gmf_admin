// lib/modules/active_users/active_users_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ActiveUsersController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Returns a stream of users who were active in the last 24 hours.
  Stream<QuerySnapshot> getActiveUsersStream() {
    final DateTime twentyFourHoursAgo = DateTime.now().subtract(const Duration(days: 1));
    final Timestamp twentyFourHoursAgoTimestamp = Timestamp.fromDate(twentyFourHoursAgo);

    return _firestore
        .collection('users')
        .where('lastLogin', isGreaterThanOrEqualTo: twentyFourHoursAgoTimestamp)
        .orderBy('lastLogin', descending: true) // Show most recent first
        .snapshots();
  }
}