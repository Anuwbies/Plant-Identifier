import 'package:flutter/material.dart';
import '../sign in/signin_page.dart';

class SignupPageModel{
  void goToSignin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SigninPage()),
    );
  }
}