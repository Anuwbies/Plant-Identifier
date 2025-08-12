import 'package:flutter/material.dart';
import 'package:flutter_projects/color/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../sign in/signin_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

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
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(LucideIcons.userRound300, size: 24),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(LucideIcons.mail300, size: 24),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      obscureText: !_passwordVisible,
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
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      obscureText: !_confirmPasswordVisible,
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
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const SigninPage()),
                                  (route) => false, // Remove all previous routes
                            );
                          },
                          style: ElevatedButton.styleFrom(minimumSize: const Size(0, 50)),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 20),
                          ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}