import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_projects/color/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../api/django_api.dart';
import '../sign in/signin_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    final result = await DjangoApi.registerUser(
      username: username,
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
        MaterialPageRoute(builder: (context) => const SigninPage()),
            (route) => false,
      );
    } else {
      final errors = result['errors'] as Map<String, dynamic>?;

      if (errors != null) {
        final newUsernameError = (errors['username'] as List?)?.first;
        final newEmailError = (errors['email'] as List?)?.first;
        final newPasswordError = (errors['password'] as List?)?.first;
        final newConfirmPasswordError = (errors['confirm_password'] as List?)?.first;

        if (newUsernameError != _usernameError ||
            newEmailError != _emailError ||
            newPasswordError != _passwordError ||
            newConfirmPasswordError != _confirmPasswordError) {
          setState(() {
            _usernameError = newUsernameError;
            _emailError = newEmailError;
            _passwordError = newPasswordError;
            _confirmPasswordError = newConfirmPasswordError;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 80, bottom: 130, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(color: AppColors.primaryA0, fontSize: 40),
                ),
                const SizedBox(height: 50),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(LucideIcons.userRound300, size: 24),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        errorText: _usernameError,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(LucideIcons.mail300, size: 24),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        errorText: _emailError,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      obscureText: !_passwordVisible,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(LucideIcons.lock300, size: 24),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              _passwordVisible ? LucideIcons.eyeOff300 : LucideIcons.eye300,
                              size: 24,
                            ),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        errorText: _passwordError,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      obscureText: !_confirmPasswordVisible,
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(LucideIcons.lockKeyhole300, size: 24),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _confirmPasswordVisible = !_confirmPasswordVisible;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              _confirmPasswordVisible ? LucideIcons.eyeOff300 : LucideIcons.eye300,
                              size: 24,
                            ),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        errorText: _confirmPasswordError,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 50)),
                      child: const Text('Sign Up', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 12, color: AppColors.surfaceA50),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SigninPage()),
                        );
                      },
                      child: Text(
                        ' Sign In',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryA20,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryA20,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}