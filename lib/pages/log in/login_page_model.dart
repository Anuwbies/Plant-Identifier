import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/user_auth_api.dart';
import '../navbar/navbar_page.dart';

class LoginPageModel {
  late BuildContext _context;
  late void Function(VoidCallback fn) _setState;

  bool passwordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  void init(BuildContext context, void Function(VoidCallback fn) setState) {
    _context = context;
    _setState = setState;
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  void togglePasswordVisibility() {
    _setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  Future<void> _saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user['userId'] ?? 0);
    await prefs.setString('first_name', user['first_name'] ?? '');
    await prefs.setString('last_name', user['last_name'] ?? '');
    await prefs.setString('email', user['email'] ?? '');
    await prefs.setString('joined_date', user['joined_date'] ?? '');
  }

  void loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final result =
    await UserAuthApi.loginUser(email: email, password: password);

    if (result['success']) {
      final user = result['user'];
      if (user != null) {
        await _saveUserData(user);
      }

      Navigator.pushAndRemoveUntil(
        _context,
        MaterialPageRoute(builder: (_) => const NavbarPage()),
            (route) => false,
      );
    } else {
      final errors = result['errors'] as Map<String, dynamic>?;

      if (errors != null) {
        final newEmailError = (errors['email'] as List?)?.first;
        final newPasswordError = (errors['password'] as List?)?.first;
        final generalError =
            (errors['__all__'] as List?)?.first; // "__all__" error

        final effectivePasswordError = newPasswordError ?? generalError;

        if (newEmailError != emailError ||
            effectivePasswordError != passwordError) {
          _setState(() {
            emailError = newEmailError;
            passwordError = effectivePasswordError;
          });
        }
      } else {
        ScaffoldMessenger.of(_context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Login failed')),
        );
      }
    }
  }
}
