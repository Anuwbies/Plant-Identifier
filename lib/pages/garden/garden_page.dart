import 'package:flutter/material.dart';
import 'package:flutter_projects/color/app_colors.dart';

import '../history/history_page.dart';
import '../myplants/myplants_page.dart';

class GardenPage extends StatelessWidget {
  const GardenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea( bottom: false,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TabBar(
              tabs: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Tab(text: 'My Plants'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Tab(text: 'History'),
                ),
              ],
              isScrollable: false,
              indicatorColor: AppColors.primaryA0,
              labelColor: AppColors.primaryA0,
              unselectedLabelColor: AppColors.surfaceA50,
              labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w800), // Selected tab text style
              unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), // Unselected tab text style
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MyplantsPage(),
                  HistoryPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
