// lib/modules/dashboard/dashboard_admin_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DashboardAdminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to get the total number of users in real-time.
  Stream<int> getTotalUsersStream() {
    return _firestore
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Stream to get the total number of challenges in real-time.
  Stream<int> getTotalChallengesStream() {
    return _firestore
        .collection('challenges')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Stream to get the number of active events in real-time.
  Stream<int> getActiveEventsStream() {
    return _firestore
        .collection('events')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // --- THIS IS THE MISSING METHOD, NOW ADDED ---
  Stream<int> getDailyActiveUsersStream() {
    // Calculate the timestamp for 24 hours ago
    final DateTime twentyFourHoursAgo = DateTime.now().subtract(const Duration(days: 1));
    final Timestamp twentyFourHoursAgoTimestamp = Timestamp.fromDate(twentyFourHoursAgo);

    return _firestore
        .collection('users')
        .where('lastLogin', isGreaterThanOrEqualTo: twentyFourHoursAgoTimestamp)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}