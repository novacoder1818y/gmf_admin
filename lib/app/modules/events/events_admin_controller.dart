import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventsAdminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Deletes an event document from Firestore after showing a confirmation dialog.
  void deleteEvent(String eventId, String eventTitle) {
    Get.defaultDialog(
      title: "Confirm Deletion",
      middleText: "Are you sure you want to permanently delete the event '$eventTitle'?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        try {
          // Perform the delete operation on the document with the given ID.
          await _firestore.collection('events').doc(eventId).delete();
          Get.back(); // Close the dialog
          Get.snackbar('Success', "'$eventTitle' has been deleted.", backgroundColor: Colors.green);
        } catch (e) {
          Get.snackbar('Error', 'Failed to delete event: $e');
        }
      },
    );
  }
}

