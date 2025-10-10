// lib/modules/manage_practice/problems/manage_problems_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageProblemsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String categoryId;
  late String categoryName;

  @override
  void onInit() {
    super.onInit();
    categoryId = Get.arguments['categoryId'] ?? '';
    categoryName = Get.arguments['categoryName'] ?? 'Problems';
    if (categoryId.isEmpty) {
      Get.snackbar('Error', 'Category ID is missing.');
    }
  }

  Stream<QuerySnapshot> getProblemsStream() {
    return _firestore
        .collection('practiceCategories')
        .doc(categoryId)
        .collection('problems')
        .snapshots();
  }

  Future<void> addProblem({
    required String title,
    required String description,
    required String difficulty,
    required String starterCode,
  }) async {
    if (title.isEmpty || description.isEmpty || starterCode.isEmpty) {
      Get.snackbar('Error', 'All fields are required.');
      return;
    }
    try {
      await _firestore
          .collection('practiceCategories')
          .doc(categoryId)
          .collection('problems')
          .add({
        'title': title,
        'description': description,
        'difficulty': difficulty,
        'starterCode': starterCode,
        'createdAt': FieldValue.serverTimestamp(),
      });
      Get.back();
      Get.snackbar('Success', 'Problem added successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add problem: $e');
    }
  }

  Future<void> updateProblem({
    required String problemId,
    required String title,
    required String description,
    required String difficulty,
    required String starterCode,
  }) async {
    if (title.isEmpty || description.isEmpty || starterCode.isEmpty) {
      Get.snackbar('Error', 'All fields are required.');
      return;
    }
    try {
      await _firestore
          .collection('practiceCategories')
          .doc(categoryId)
          .collection('problems')
          .doc(problemId)
          .update({
        'title': title,
        'description': description,
        'difficulty': difficulty,
        'starterCode': starterCode,
      });
      Get.back();
      Get.snackbar('Success', 'Problem updated successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update problem: $e');
    }
  }

  Future<void> deleteProblem(String problemId) async {
    try {
      await _firestore
          .collection('practiceCategories')
          .doc(categoryId)
          .collection('problems')
          .doc(problemId)
          .delete();
      Get.snackbar('Success', 'Problem deleted successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete problem: $e');
    }
  }
}