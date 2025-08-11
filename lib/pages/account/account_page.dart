import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea( bottom: false,
      child: Align( alignment: Alignment.topCenter,
        child: Column(
          children: [
            SizedBox( height: 60,),
            SizedBox(
              width: 300,
              height: 400,
              child: Container(
                color: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Your onPressed action here
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(2),
                elevation: 6,
                backgroundColor: Colors.white,
              ),
              child: const Icon( LucideIcons.circle200,
                size: 60,
                color: Colors.black,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
