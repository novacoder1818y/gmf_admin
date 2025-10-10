import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedAdminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void deletePost(String postId, String postTitle) {
    Get.defaultDialog(
      title: "Confirm Deletion",
      middleText: "Are you sure you want to delete the post '$postTitle'?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        try {
          await _firestore.collection('codeFeed').doc(postId).delete();
          Get.back(); // Close dialog
          Get.snackbar('Success', "'$postTitle' has been deleted.", backgroundColor: Colors.green);
        } catch (e) {
          Get.snackbar('Error', 'Failed to delete post: $e');
        }
      },
    );
  }
}
