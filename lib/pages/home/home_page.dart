import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Home')),
    Center(child: Text('Garden')),
    Center(child: Text('Account')),
    Center(child: Text('Camera')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: StylishBottomBar(option: BubbleBarOptions(
          barStyle: BubbleBarStyle.vertical,
          opacity: 0.3,
        ),
        items: [
          BottomBarItem(icon: const Icon(Icons.home), title: const Text('Home')),
          BottomBarItem(icon: const Icon(Icons.energy_savings_leaf), title: const Text('Garden')),
          BottomBarItem(icon: const Icon(Icons.person), title: const Text('Account')),
          BottomBarItem(icon: const Icon(Icons.camera_alt), title: const Text('Camera')),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}