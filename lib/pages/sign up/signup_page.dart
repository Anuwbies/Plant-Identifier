import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Align( alignment: Alignment.topCenter,
            child: Padding( padding: const EdgeInsets.only(top: 80, bottom: 80),
              child: Text("Signup Page", style: TextStyle(color: Colors.white),),
            ),
          )
      ),
    );
  }
}
