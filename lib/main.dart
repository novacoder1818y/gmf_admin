// main.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmfc_admin/firebase_options.dart';
import 'app/controllers/theme_controller.dart';
import 'app/modules/auth/auth_controller.dart';
import 'app/routes/admin_pages.dart';
import 'app/routes/admin_routes.dart';
import 'app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Register controllers with permanent:true to keep them alive
  Get.put(ThemeController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  runApp(const AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the globally available ThemeController.
    final ThemeController themeController = Get.find();
    final AuthController authController = Get.find();

    return Obx(
          () => GetMaterialApp(
        title: 'Gamified Coding Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // Set the light theme
        darkTheme: AppTheme.darkTheme, // Set the dark theme
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        // The home property will now determine the initial screen based on auth state
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Show a loading indicator while the connection is active
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Check if user data exists, email is verified, and matches the admin email
            if (snapshot.hasData && snapshot.data!.emailVerified && snapshot.data!.email == authController.adminEmail) {
              // If user is a verified admin, go to the main panel
              // We use a WidgetsBinding to navigate after the build is complete
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offAllNamed(Routes.MAIN);
              });
            } else {
              // Otherwise, go to the authentication screen
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offAllNamed(Routes.AUTH);
              });
            }

            // Return a loading screen that will be replaced after navigation
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
        getPages: AdminPages.routes,
      ),
    );
  }
}