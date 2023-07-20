import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_api_app/controllers/auth_controller.dart';
import 'package:news_api_app/routes.dart';

class LoginController {
  AuthController authController = Get.find<AuthController>();

  Future<void> signInWithGoogle(BuildContext context) async {
    await authController.signInWithGoogle();
    // ignore: use_build_context_synchronously
    if (!context.mounted) return;
    await Navigator.pushNamedAndRemoveUntil(
      context,
      CustomRoutes.homeWrapper,
      (route) => false,
    );
  }
}
