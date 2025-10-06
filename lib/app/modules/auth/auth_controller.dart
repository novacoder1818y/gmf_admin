import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLogin = true.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  void toggleForm() => isLogin.value = !isLogin.value;
  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
}


