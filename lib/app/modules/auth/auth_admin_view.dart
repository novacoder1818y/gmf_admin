import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import 'auth_controller.dart';
import 'login.dart';
import 'signup.dart';

class AuthAdminView extends StatefulWidget {
  const AuthAdminView({super.key});

  @override
  State<AuthAdminView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthAdminView> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _controller2 = AnimationController(vsync: this, duration: const Duration(seconds: 15));

    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(tween: AlignmentTween(begin: Alignment.topLeft, end: Alignment.topRight), weight: 1),
      TweenSequenceItem(tween: AlignmentTween(begin: Alignment.topRight, end: Alignment.bottomRight), weight: 1),
      TweenSequenceItem(tween: AlignmentTween(begin: Alignment.bottomRight, end: Alignment.bottomLeft), weight: 1),
      TweenSequenceItem(tween: AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.topLeft), weight: 1),
    ]).animate(_controller1);

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(tween: AlignmentTween(begin: Alignment.bottomRight, end: Alignment.topLeft), weight: 1),
      TweenSequenceItem(tween: AlignmentTween(begin: Alignment.topLeft, end: Alignment.bottomLeft), weight: 1),
      TweenSequenceItem(tween: AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.topRight), weight: 1),
      TweenSequenceItem(tween: AlignmentTween(begin: Alignment.topRight, end: Alignment.bottomRight), weight: 1),
    ]).animate(_controller2);

    _controller1.repeat();
    _controller2.repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      body: Stack(
        children: [
          Container(color: AppTheme.primaryColor),
          AnimatedBuilder(
            animation: Listenable.merge([_controller1, _controller2]),
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                      child: const SizedBox(),
                    ),
                  ),
                  Align(alignment: _topAlignmentAnimation.value, child: _buildBlob(AppTheme.accentColor, 400)),
                  Align(alignment: _bottomAlignmentAnimation.value, child: _buildBlob(AppTheme.secondaryColor, 300)),
                ],
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shield_outlined, size: 60, color: Colors.white),
                      const SizedBox(height: 50),
                      Obx(
                            () => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          child: authController.isLogin.value
                              ? const LoginWidget(key: ValueKey('login'))
                              : const SignupWidget(key: ValueKey('signup')),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Obx(
                            () => TextButton(
                          onPressed: authController.toggleForm,
                          child: Text(
                            authController.isLogin.value
                                ? "Need an admin account? Register"
                                : "Already have an account? Login",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.6), color.withOpacity(0)],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}