import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/features/basket/presentation/pages/basket_page.dart';
import 'package:zaza_app/features/categories/presentation/pages/categories_page.dart';
import 'package:zaza_app/features/home/presentation/pages/home_page.dart';
import 'package:zaza_app/features/search/presentation/pages/search_page.dart';
import 'package:zaza_app/features/settings/presentation/pages/settings_page.dart';
import 'package:badges/badges.dart' as badges;

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
      icon: BlocBuilder<BasketBloc, BasketState>(
        builder: (context, state) {
          int itemCount = state.basketProductsList!.length;
          return state.basketProductsList!.isNotEmpty
              ? badges.Badge(
                  badgeContent: Text(
                    '$itemCount',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.circle,
                    badgeColor: Colors.red,
                    padding: EdgeInsets.all(4),
                    borderRadius: BorderRadius.circular(8),
                    elevation: 0,
                  ),
                  child: Icon(Icons.shopping_basket, size: 26),
                )
              : const Icon(
                  Icons.shopping_basket,
                  size: 26,
                );
        },
      ),
      title: (AppLocalizations.of(context)!.basket),
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

List<Widget> screens = [
  HomePage(),
  CategoryPage(),
  SearchPage(),
  BasketPage(),
  SettingsPage(),
  //const CategoriesScreen(),
  //SearchScreen(),
  //BasketScreen(),
  //const SettingsScreen(),
];
