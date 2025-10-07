import 'package:flutter/material.dart';
import '../log in/login_page.dart';
import '../sign up/signup_page.dart';

class WelcomePageModel {
  void goToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
  }

  void goToSignin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
