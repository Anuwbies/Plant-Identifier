import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'home_page_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageModel _model = HomePageModel();

  void _onTabSelected(int index) {
    setState(() {
      _model.selectedIndex = index;
    });
  }

  void _onCameraPressed() {
    // Open Camera
    debugPrint("Camera button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _model.pages[_model.selectedIndex],
      bottomNavigationBar: SizedBox( height: 65,
        child: StylishBottomBar(
          option: AnimatedBarOptions( iconSize: 25, barAnimation: BarAnimation.fade, iconStyle: IconStyle.animated,
          ),
          items: [
            BottomBarItem( icon: const Icon(LucideIcons.house400), title: const Text('Home', style: TextStyle(fontSize: 14)),
            ),
            BottomBarItem( icon: const Icon(LucideIcons.sprout400), title: const Text('Garden', style: TextStyle(fontSize: 14)),
            ),
            BottomBarItem( icon: const Icon(LucideIcons.userRound400), title: const Text('Account', style: TextStyle(fontSize: 14)),
            ),
          ],
          fabLocation: StylishBarFabLocation.end,
          hasNotch: true,
          notchStyle: NotchStyle.circle,
          backgroundColor: Colors.white10,
          currentIndex: _model.selectedIndex,
          onTap: _onTabSelected,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        onPressed: _onCameraPressed,
        child: const Icon(LucideIcons.camera, color: Colors.white),
      ),
    );
  }
}
