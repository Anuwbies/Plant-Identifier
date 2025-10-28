import 'package:flutter/material.dart';
import 'package:flutter_projects/color/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'login_page_model.dart';
import '../sign up/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginPageModel _model = LoginPageModel();

  @override
  void initState() {
    super.initState();
    _model.init(context, setState);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding:
            const EdgeInsets.only(top: 80, bottom: 50, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Log In",
                  style: TextStyle(color: AppColors.primaryA0, fontSize: 40),
                ),
                const SizedBox(height: 50),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _model.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(LucideIcons.mail, size: 24),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20),
                        errorText: _model.emailError,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _model.passwordController,
                      obscureText: !_model.passwordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(LucideIcons.lockKeyhole, size: 24),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: _model.togglePasswordVisibility,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              _model.passwordVisible
                                  ? LucideIcons.eyeOff
                                  : LucideIcons.eye,
                              size: 24,
                            ),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20),
                        errorText: _model.passwordError,
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
                      onPressed: _model.loginUser,
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 50)),
                      child: const Text(
                        'Log In',
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
                      style:
                      TextStyle(fontSize: 12, color: AppColors.surfaceA50),
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
                    )
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
