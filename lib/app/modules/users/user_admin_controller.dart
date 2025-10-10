// lib/modules/users/users_admin_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';

class UsersAdminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var allUsers = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    allUsers.bindStream(
      _firestore.collection('users').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
      }),
    );
    ever(allUsers, (_) => filterUsers(''));
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(allUsers);
    } else {
      String lowercasedQuery = query.toLowerCase();
      filteredUsers.assignAll(allUsers.where((user) {
        return user.name.toLowerCase().contains(lowercasedQuery) ||
            user.email.toLowerCase().contains(lowercasedQuery);
      }).toList());
    }
  }

  /// Sets a user's isSuspended status to true in Firestore.
  Future<void> suspendUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update({'isSuspended': true});
      Get.snackbar('Success', "'${user.name}' has been suspended.", backgroundColor: Colors.orange);
      // THIS IS THE FIX: Manually refresh the list to ensure Obx widgets update
      allUsers.refresh();
      filteredUsers.refresh();
    } catch (e) {
      Get.snackbar('Error', 'Failed to suspend user: $e');
    }
  }

  /// Sets a user's isSuspended status to false in Firestore.
  Future<void> unsuspendUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update({'isSuspended': false});
      Get.snackbar('Success', "'${user.name}' has been unsuspended.", backgroundColor: Colors.green);
      // THIS IS THE FIX: Manually refresh the list to ensure Obx widgets update
      allUsers.refresh();
      filteredUsers.refresh();
    } catch (e) {
      Get.snackbar('Error', 'Failed to unsuspend user: $e');
    }
  }
}