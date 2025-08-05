import 'package:flutter/material.dart';
import 'welcome_page_model.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = WelcomePageModel();

    return Scaffold(
      body: SafeArea(
        child: Align(alignment: Alignment.topCenter,
          child: Padding( padding: const EdgeInsets.only(top: 80, bottom: 80),
            child: Column( mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column( mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset( 'lib/images/plant_logo.png', width: 200, height: 200,
                    ),
                    Text( 'Plant Identifier', style: TextStyle(fontSize: 30, letterSpacing: 2, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column( mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding( padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container( width: double.infinity,
                        child: ElevatedButton( onPressed: () => model.goToSignup(context), style: ElevatedButton.styleFrom( minimumSize: Size(0, 50), backgroundColor: Colors.green),
                          child: Text('Get Started', style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row( mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text( 'Already have an account?', style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        SizedBox(width: 10), // spacing between texts
                        GestureDetector(onTap: () => model.goToSignin(context),
                          child: Text( 'Sign In', style: TextStyle(fontSize: 12, color: Colors.white, decoration: TextDecoration.underline, decorationColor: Colors.white),
                          ),
                        ),
                      ],
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