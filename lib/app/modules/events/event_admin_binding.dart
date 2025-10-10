import 'package:get/get.dart';
import '../challenges/challenges_controller.dart';
import '../events/events_admin_controller.dart'; // <-- ADD THIS IMPORT
import '../main/admin_main_controller.dart';

class AdminMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminMainController>(() => AdminMainController());
    Get.lazyPut<ChallengesController>(() => ChallengesController());

    // THIS IS THE FIX:
    // We are now also creating the EventsAdminController here, so it's
    // available to the Events page within the main navigation shell.
    Get.lazyPut<EventsAdminController>(() => EventsAdminController());
  }
}