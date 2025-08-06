import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../home/home_page.dart';

class NavbarPageModel {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    Center(child: Text('Garden')),
    Center(child: Text('Account')),
  ];

  final List<BottomNavigationBarItem> bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(LucideIcons.house400),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(LucideIcons.sprout400),
      label: 'Garden',
    ),
    BottomNavigationBarItem(
      icon: Icon(LucideIcons.userRound400),
      label: 'Account',
    ),
  ];
}
