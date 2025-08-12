import 'package:flutter/material.dart';
import 'package:flutter_projects/color/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../navbar/navbar_page.dart';
import '../sign up/signup_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool _passwordVisible = false;

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
                  "Sign In",
                  style: TextStyle(color: AppColors.primaryA0, fontSize: 40),
                ),
                const SizedBox(height: 50),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
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
                          child: Icon(LucideIcons.lockKeyhole300, size: 24),
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const NavbarPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(minimumSize: const Size(0, 50)),
                          child: const Text(
                            'Sign In',
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
                          "Don't Have an account?",
                          style: TextStyle(fontSize: 12, color: AppColors.surfaceA50),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const SignupPage()),
                            );
                          },
                          child: Text(
                            ' Sign Up',
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
