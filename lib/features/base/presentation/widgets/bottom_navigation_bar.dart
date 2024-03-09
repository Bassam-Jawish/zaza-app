import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../config/theme/colors.dart';
import 'bottom_items.dart';

class PersistentBottomNavigationBar extends StatelessWidget {
  const PersistentBottomNavigationBar({Key? key}) : super(key: key);

  //final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
/*
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Section A'),
        BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Section B'),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: navigationShell.currentIndex,
      onTap: (int index) {
        if (index != navigationShell.currentIndex) {
          navigationShell.goBranch(
            index,
            initialLocation: true, // Set initialLocation to true for different branches
          );
        }
      },
    );
*/
    return SafeArea(
      child: PersistentTabView(
        context,
        screens: screens,
        items: bottomItems(context),
        controller: PersistentTabController(initialIndex: 0),
        confineInSafeArea: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.bottomNavigationBarLight,
        handleAndroidBackButtonPress: true,
        popActionScreens: PopActionScreensType.once,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        navBarStyle: NavBarStyle.style14,
      ),
    );
  }
}
