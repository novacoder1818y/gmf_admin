// auth_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/admin_routes.dart';

class AuthController extends GetxController {
  // Firebase Instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Form Text Editing Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController(); // For signup

  // Hardcoded admin email for the primary security check
  final String _adminEmail = "novacoder283@gmail.com";
  // Public getter for other parts of the app to access the admin email
  String get adminEmail => _adminEmail;


  // UI State Management
  var isLogin = true.obs;
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  // --- UI Methods ---
  void toggleForm() => isLogin.value = !isLogin.value;
  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;

  // --- Firebase Sign Up Method ---
  Future<void> signUpAdminWithEmail() async {
    if (fullNameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    isLoading.value = true;
    try {
      // Step 1: Create user with Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Step 2: Create a corresponding user document in Firestore with an 'admin' role
      if (userCredential.user != null) {
        await _createAdminDocumentInFirestore(userCredential.user!);
        // Step 3: Send verification email
        await userCredential.user!.sendEmailVerification();
        _showVerificationDialog();
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Sign Up Failed', e.message ?? 'An unknown error occurred.');
    } finally {
      isLoading.value = false;
    }
  }

  // --- Firebase Sign In Method (with Security Checks) ---
  Future<void> signInAdminWithEmail() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Email and password are required.');
      return;
    }
    isLoading.value = true;
    try {
      // Step 1: Sign in with Firebase Auth
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(code: 'user-not-found');
      }

      // Step 2: SECURITY CHECK - Is this the designated admin email?
      if (user.email != adminEmail) { // Using the public getter
        await _auth.signOut(); // Immediately sign out the unauthorized user
        Get.snackbar('Access Denied', 'You are not authorized to access this panel.');
        isLoading.value = false;
        return;
      }

      // Step 3: SECURITY CHECK - Is the admin's email verified?
      await user.reload(); // Refresh user data to get the latest verification status
      final refreshedUser = _auth.currentUser;
      if (refreshedUser == null || !refreshedUser.emailVerified) {
        await _auth.signOut();
        Get.snackbar('Verification Required', 'Please check your inbox and verify your email address before logging in.');
        isLoading.value = false;
        return;
      }

      // If all checks pass, navigate to the main panel
      // The StreamBuilder in main.dart will handle navigation, but this is a fallback.
      Get.offAllNamed(Routes.MAIN);

    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Failed', e.message ?? 'An unknown error occurred.');
    } finally {
      isLoading.value = false;
    }
  }

  // --- Firebase Sign Out Method ---
  Future<void> logout() async {
    try {
      await _auth.signOut();
      // Navigation is handled by the StreamBuilder in main.dart, but this is a failsafe.
      Get.offAllNamed(Routes.AUTH);
    } catch (e) {
      Get.snackbar('Logout Failed', 'An error occurred while logging out.');
    }
  }

  // --- Helper Methods ---
  Future<void> _createAdminDocumentInFirestore(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    await userDoc.set({
      'name': fullNameController.text.trim(),
      'email': user.email,
      'joinedDate': Timestamp.now(),
      'role': 'admin', // Explicitly set role as admin
    });
  }

  void _showVerificationDialog() {
    Get.defaultDialog(
      title: "Verify Your Email",
      middleText: "A verification link has been sent to your email address. Please check your inbox and verify your account to log in.",
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      onConfirm: () {
        isLogin.value = true; // Switch back to the login form
        Get.back(); // Close the dialog
      },
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    super.onClose();
  }
}