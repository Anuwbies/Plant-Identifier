import 'package:flutter/material.dart';
import 'package:flutter_projects/pages/sign%20up/signup_page.dart';
import '../navbar/navbar_page.dart';

class SigninPageModel{

  void goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => NavbarPage()),
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