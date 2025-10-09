import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/models/challenge_model.dart';

class ChallengesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var challengesList = <ChallengeModel>[].obs;
  var filteredChallenges = <ChallengeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    challengesList.bindStream(_firestore.collection('challenges').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ChallengeModel.fromFirestore(doc)).toList();
    }));
    ever(challengesList, (_) => filterChallenges(''));
  }

  void filterChallenges(String query) {
    if (query.isEmpty) {
      filteredChallenges.assignAll(challengesList);
    } else {
      filteredChallenges.assignAll(challengesList.where((c) => c.title.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void deleteChallenge(ChallengeModel challenge) {
    Get.defaultDialog(
      title: "Confirm Deletion",
      middleText: "Are you sure you want to delete '${challenge.title}'?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        try {
          await _firestore.collection('challenges').doc(challenge.id).delete();
          Get.back(); // Close dialog
          Get.snackbar('Success', "'${challenge.title}' has been deleted.", backgroundColor: Colors.green);
        } catch (e) {
          Get.snackbar('Error', 'Failed to delete challenge: $e');
        }
      },
    );
  }
}