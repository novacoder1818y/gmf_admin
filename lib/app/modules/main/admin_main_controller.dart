import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../challenges/challenges_admin_view.dart';
import '../dashboard/dashboard_admin_view.dart';
import '../events/events_admin_view.dart';
import '../settings/settings_admin_view.dart';
import '../users/users_admin_view.dart';

class AdminMainController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> pages = [
    const DashboardAdminView(),
    const ChallengesAdminView(),
    const EventsAdminView(),
    const UsersAdminView(),
    const SettingsAdminView(),
  ];

  void changePage(int index) {
    selectedIndex.value = index;
  }
}