import 'package:flutter/material.dart';
import 'package:flutter_projects/color/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/user_auth_api.dart';
import '../navbar/navbar_page.dart';
import '../sign up/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  Future<void> _saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user['userId'] ?? 0);
    await prefs.setString('first_name', user['first_name'] ?? '');
    await prefs.setString('last_name', user['last_name'] ?? '');
    await prefs.setString('email', user['email'] ?? '');
    await prefs.setString('joined_date', user['joined_date'] ?? '');
  }


  void _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final result = await UserAuthApi.loginUser(email: email, password: password);

    if (result['success']) {
      final user = result['user'];
      if (user != null) {
        await _saveUserData(user);
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const NavbarPage()),
            (route) => false,
      );
    } else {
      final errors = result['errors'] as Map<String, dynamic>?;

      if (errors != null) {
        final newEmailError = (errors['email'] as List?)?.first;
        final newPasswordError = (errors['password'] as List?)?.first;
        final generalError = (errors['__all__'] as List?)?.first; // Catch "__all__" error

        // If "__all__" exists, display it as a password error
        final effectivePasswordError = newPasswordError ?? generalError;

        if (newEmailError != _emailError || effectivePasswordError != _passwordError) {
          setState(() {
            _emailError = newEmailError;
            _passwordError = effectivePasswordError;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Login failed')),
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
            padding: const EdgeInsets.only(top: 80, bottom: 50, left: 20, right: 20),
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
                      controller: _emailController,
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        errorText: _emailError,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(LucideIcons.lockKeyhole, size: 24),
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
                              _passwordVisible ? LucideIcons.eyeOff : LucideIcons.eye,
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
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loginUser,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 50)),
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
