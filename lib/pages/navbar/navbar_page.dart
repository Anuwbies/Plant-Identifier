import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'navbar_page_model.dart';

class NavbarPage extends StatefulWidget {
  const NavbarPage({super.key});

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  final NavbarPageModel _model = NavbarPageModel();
  final ImagePicker _picker = ImagePicker();

  void _onTabSelected(int index) {
    setState(() {
      _model.selectedIndex = index;
    });
  }

  Future<void> _onCameraPressed() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // You can display, upload, or process the image here
      debugPrint('Captured image path: ${image.path}');
    } else {
      debugPrint('Camera closed without taking a picture.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Colors.transparent, extendBody: true, resizeToAvoidBottomInset: false,
      body: _model.pages[_model.selectedIndex],
      bottomNavigationBar: SizedBox( height: 65,
        child: StylishBottomBar(
          option: AnimatedBarOptions( iconSize: 20, barAnimation: BarAnimation.fade, iconStyle: IconStyle.Default,
          ),
          items: [
            BottomBarItem( icon: const Icon(LucideIcons.house400), title: const Text('Home', style: TextStyle(fontSize: 12)),
            ),
            BottomBarItem( icon: const Icon(LucideIcons.sprout400), title: const Text('Garden', style: TextStyle(fontSize: 12)),
            ),
            BottomBarItem( icon: const Icon(LucideIcons.userRound400), title: const Text('Account', style: TextStyle(fontSize: 12)),
            ),
          ],
          fabLocation: StylishBarFabLocation.end,
          hasNotch: true,
          notchStyle: NotchStyle.circle,
          backgroundColor: Color.fromRGBO(33, 33, 33, 0.7),
          currentIndex: _model.selectedIndex,
          onTap: _onTabSelected,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        onPressed: _onCameraPressed,
        child: const Icon(LucideIcons.camera400, color: Colors.white, size: 28),
      ),
    );
  }
}
