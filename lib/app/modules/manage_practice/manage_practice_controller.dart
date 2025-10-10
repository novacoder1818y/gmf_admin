// lib/modules/manage_practice/manage_practice_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagePracticeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of practice categories
  Stream<QuerySnapshot> getCategoriesStream() {
    return _firestore.collection('practiceCategories').orderBy('order').snapshots();
  }

  // Add a new category
  Future<void> addCategory(String name, int order) async {
    if (name.isEmpty) {
      Get.snackbar('Error', 'Category name cannot be empty.');
      return;
    }
    try {
      // THIS IS THE CHANGE: The 'icon' field is now removed.
      await _firestore.collection('practiceCategories').add({
        'name': name,
        'order': order,
      });
      Get.back(); // Close dialog
      Get.snackbar('Success', 'Category added successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add category: $e');
    }
  }

  // Update an existing category
  Future<void> updateCategory(String docId, String newName, int newOrder) async {
    if (newName.isEmpty) {
      Get.snackbar('Error', 'Category name cannot be empty.');
      return;
    }
    try {
      await _firestore.collection('practiceCategories').doc(docId).update({
        'name': newName,
        'order': newOrder,
      });
      Get.back(); // Close dialog
      Get.snackbar('Success', 'Category updated successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update category: $e');
    }
  }

  // Delete a category
  Future<void> deleteCategory(String docId) async {
    try {
      // IMPORTANT: Deleting a document does NOT delete its subcollections.
      // For a production app, you would need a Cloud Function to delete all problems
      // within this category to avoid orphaned data.
      await _firestore.collection('practiceCategories').doc(docId).delete();
      Get.snackbar('Success', 'Category deleted. Remember to clean up subcollections via Cloud Functions.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete category: $e');
    }
  }
}