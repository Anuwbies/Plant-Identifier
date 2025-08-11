import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../color/app_colors.dart';
import 'welcome_page_model.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = WelcomePageModel();

    return Scaffold( resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Align(alignment: Alignment.topCenter,
          child: Padding( padding: const EdgeInsets.only(top: 80, bottom: 80),
            child: Column( mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column( mainAxisSize: MainAxisSize.min, spacing: 15,
                  children: [
                    SvgPicture.asset( 'assets/images/logo.svg',
                    width: 150, height: 150,
                    ),
                    Text( 'Plant Identifier', style: TextStyle(fontSize: 30, letterSpacing: 2, color: AppColors.primaryDark10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column( mainAxisSize: MainAxisSize.min, spacing: 20,
                  children: [
                    Padding( padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SizedBox( width: double.infinity,
                        child: ElevatedButton( onPressed: () => model.goToSignup(context), style: ElevatedButton.styleFrom( minimumSize: Size(0, 50)),
                          child: Text('Get Started', style: TextStyle(fontSize: 20,),
                          ),
                        ),
                      ),
                    ),
                    Row( mainAxisAlignment: MainAxisAlignment.center, spacing: 5,
                      children: [
                        Text( 'Already have an account?', style: TextStyle(fontSize: 12, color: AppColors.surfaceA50),
                        ),
                        GestureDetector(onTap: () => model.goToSignin(context),
                          child: Text( 'Sign In', style: TextStyle(fontSize: 12, color: AppColors.primaryA20, decoration: TextDecoration.underline, decorationColor: AppColors.primaryA20),
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