import 'package:flutter/material.dart';
import 'package:flutter_projects/api/user_auth_api.dart';
import '../log in/login_page.dart';

class SignupPageModel {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  String? firstNameError;
  String? lastNameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void togglePasswordVisibility(void Function(void Function()) setState) {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  void toggleConfirmPasswordVisibility(void Function(void Function()) setState) {
    setState(() {
      confirmPasswordVisible = !confirmPasswordVisible;
    });
  }

  Future<void> registerUser(BuildContext context, void Function(void Function()) setState) async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final result = await UserAuthApi.registerUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
      );
    } else {
      final errors = result['errors'] as Map<String, dynamic>?;

      if (errors != null) {
        setState(() {
          firstNameError = (errors['first_name'] as List?)?.first;
          lastNameError = (errors['last_name'] as List?)?.first;
          emailError = (errors['email'] as List?)?.first;
          passwordError = (errors['password'] as List?)?.first;
          confirmPasswordError = (errors['confirm_password'] as List?)?.first;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed')),
        );
      }
    }
  }

  void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
