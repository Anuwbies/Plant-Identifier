import 'package:flutter/material.dart';
import 'package:flutter_projects/pages/account/account_page.dart';
import 'package:flutter_projects/pages/garden/garden_page.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../chat bot/chat_bot_page.dart';
import '../home/home_page.dart';

class NavbarPageModel {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    GardenPage(),
    ChatBotPage(),
    AccountPage(),
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
      icon: Icon(LucideIcons.sprout400),
      label: 'Chat-bot',
    ),
    BottomNavigationBarItem(
      icon: Icon(LucideIcons.userRound400),
      label: 'Account',
    ),
  ];
}
