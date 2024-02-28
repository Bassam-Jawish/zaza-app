
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaza_app/features/categories/presentation/pages/categories_page.dart';
import 'package:zaza_app/features/home/presentation/pages/home_page.dart';

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
        Icons.shopping_basket,
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
  HomePage(),
  CategoryPage(),
  HomePage(),
  HomePage(),
  HomePage(),
  //const CategoriesScreen(),
  //SearchScreen(),
  //BasketScreen(),
  //const SettingsScreen(),
];
