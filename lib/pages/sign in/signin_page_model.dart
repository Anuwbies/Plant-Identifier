import 'package:flutter/material.dart';
import 'package:flutter_projects/pages/sign%20up/signup_page.dart';
import '../home/home_page.dart';

class SigninPageModel{

  void goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
    );
  }

  void goToSignup(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
  }
}