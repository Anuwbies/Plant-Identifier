import 'package:flutter/material.dart';
import 'package:flutter_projects/color/app_colors.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../camera/camera_page.dart';
import 'navbar_page_model.dart';

class NavbarPage extends StatefulWidget {
  const NavbarPage({super.key});

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  final NavbarPageModel _model = NavbarPageModel();

  void _onTabSelected(int index) {
    setState(() {
      _model.selectedIndex = index;
    });
  }

  void _onCameraPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CameraPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBody: true, resizeToAvoidBottomInset: false,
      body: _model.pages[_model.selectedIndex],
      bottomNavigationBar: SizedBox( height: 65,
        child: StylishBottomBar(
          option: AnimatedBarOptions( iconSize: 20, barAnimation: BarAnimation.fade, iconStyle: IconStyle.Default,
          ),
          items: [
            BottomBarItem( icon: const Icon(LucideIcons.house400), title: const Text('Home', style: TextStyle(fontSize: 12)), selectedColor: AppColors.primaryDark10, unSelectedColor: AppColors.surfaceA50
            ),
            BottomBarItem( icon: const Icon(LucideIcons.sprout400), title: const Text('Garden', style: TextStyle(fontSize: 12)), selectedColor: AppColors.primaryDark10, unSelectedColor: AppColors.surfaceA50
            ),
            BottomBarItem( icon: const Icon(LucideIcons.userRound400), title: const Text('Account', style: TextStyle(fontSize: 12)), selectedColor: AppColors.primaryDark10, unSelectedColor: AppColors.surfaceA50
            ),
          ],
          fabLocation: StylishBarFabLocation.end,
          hasNotch: true,
          notchStyle: NotchStyle.circle,
          backgroundColor: AppColors.surfaceA10.withAlpha(179),
          currentIndex: _model.selectedIndex,
          onTap: _onTabSelected,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryDark10,
        shape: const CircleBorder(),
        onPressed: _onCameraPressed,
        child: const Icon(Icons.camera_alt_rounded, color: AppColors.surfaceA80, size: 28,),
      ),
    );
  }
}
