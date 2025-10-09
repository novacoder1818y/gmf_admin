import 'package:get/get.dart';
import 'auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Inject the AuthController so it's available to the AuthView
    Get.lazyPut<AuthController>(() => AuthController());
  }
}