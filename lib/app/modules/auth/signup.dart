import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../widgets/neon_button.dart';
import 'auth_controller.dart';

class SignupWidget extends GetView<AuthController> {
  const SignupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Create Admin Account',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 40),
        TextFormField(
          controller: controller.fullNameController, // Connect controller
          decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: controller.emailController, // Connect controller
          decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        Obx(
              () => TextFormField(
            controller: controller.passwordController, // Connect controller
            obscureText: !controller.isPasswordVisible.value,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Obx(() => controller.isLoading.value
            ? const CircularProgressIndicator()
            : NeonButton(
          text: 'Create Account & Verify',
          onTap: controller.signUpAdminWithEmail, // Call the sign-up method
          gradientColors: const [Colors.purpleAccent, Colors.pinkAccent],
        )),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}
