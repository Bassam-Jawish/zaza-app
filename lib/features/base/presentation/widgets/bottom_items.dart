
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../config/theme/colors.dart';

List<PersistentBottomNavBarItem> bottomItems(context) {
  var theme = Theme.of(context).colorScheme;
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(
        Icons.home,
        size: 26,
      ),
      title: (AppLocalizations.of(context)!.home),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: theme.background,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(
        Icons.category,
        size: 26,
      ),
      title: (AppLocalizations.of(context)!.categories),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: theme.background,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(
        Icons.search,
        size: 26,
      ),
      title: (AppLocalizations.of(context)!.search),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: theme.background,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(
        Icons.more_horiz,
        size: 26,
      ),
      title: (AppLocalizations.of(context)!.more),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: theme.background,
    ),
  ];
}

List<Widget> screens = const [
  //HomeScreen(),
  //const CategoriesScreen(),
  //SearchScreen(),
  //BasketScreen(),
  //const SettingsScreen(),
];
