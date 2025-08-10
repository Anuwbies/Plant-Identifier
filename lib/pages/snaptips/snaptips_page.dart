import 'package:flutter/material.dart';
import '../../color/app_colors.dart';

class SnapTipsPage extends StatelessWidget {
  const SnapTipsPage({super.key});

  Widget _tipItem(String imagePath, String label) {
    return SizedBox( width: 90,
      child: Column( spacing: 8,
        children: [
          Image.asset( imagePath, width: 90, height: 90,
          ),
          Text( label,
            style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: AppColors.surfaceA0,
      body: SafeArea(
        child: Padding( padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          child: Column( mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text( "Snap Tips", style: TextStyle(color: Colors.white, fontSize: 22),),
              Spacer(),
              Image.asset( 'lib/images/circle.png',
                width: 190, height: 190,
              ),
              const SizedBox(height: 50),
              Row( spacing: 3,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _tipItem('lib/images/circle.png', 'Too close'),
                  _tipItem('lib/images/circle.png', 'Too far'),
                  _tipItem('lib/images/circle.png', 'Multi-species'),
                ],
              ),
              const Spacer(),
              SizedBox( width: double.infinity, height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryA0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text( "Got it",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
