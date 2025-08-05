import 'package:flutter/material.dart';
import 'package:flutter_projects/pages/sign%20in/signin_page_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = SigninPageModel();

    return Scaffold( resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Align( alignment: Alignment.topCenter,
            child: Padding( padding: const EdgeInsets.only(top: 80, bottom: 130, left: 20, right: 20),
                child: Column( mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Sign In", style: TextStyle(color: Colors.green, fontSize: 40)),
                    const SizedBox(height: 50,), //space
                    const Column( mainAxisSize: MainAxisSize.min, spacing: 15,
                      children: [
                        TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Padding(padding: EdgeInsets.only(left: 10), child: Icon(LucideIcons.mail300, size: 24),),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),),),
                        TextField(obscureText: true, decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Padding(padding: EdgeInsets.only(left: 10), child: Icon(LucideIcons.lockKeyhole300, size: 24),),
                          suffixIcon: Padding(padding: EdgeInsets.only(right: 10), child: Icon(LucideIcons.eye300, size: 24),),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),),),
                      ],
                    ),
                    Spacer(),
                    Column(mainAxisSize: MainAxisSize.min, spacing: 20,
                      children: [
                        Padding( padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox( width: double.infinity,
                            child: ElevatedButton( onPressed: () => model.goToHome(context), style: ElevatedButton.styleFrom( minimumSize: const Size(0, 50), backgroundColor: Colors.green),
                              child: const Text('Sign In', style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Row( mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text( "Don't Have an account?", style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                            SizedBox(width: 10), // spacing between texts
                            GestureDetector(onTap: () => model.goToSignup(context),
                              child: Text( 'Sign Up', style: TextStyle(fontSize: 12, color: Colors.white, decoration: TextDecoration.underline, decorationColor: Colors.white),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )
            ),
          )
      ),
    );
  }
}