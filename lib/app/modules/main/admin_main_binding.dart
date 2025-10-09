import 'package:get/get.dart';
import '../challenges/challenges_controller.dart';
import 'admin_main_controller.dart';

class AdminMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminMainController>(() => AdminMainController());

    // THIS IS THE FIX:
    // We are now creating the ChallengesController here, so it's
    // available to any page within the main navigation shell.
    Get.lazyPut<ChallengesController>(() => ChallengesController());
  }
}