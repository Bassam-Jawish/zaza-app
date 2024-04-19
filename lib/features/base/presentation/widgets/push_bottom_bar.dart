import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

Future<void> pushNewScreenWithNavBar(context, screen, routeName) async {
  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
    context,
    withNavBar: false,
    settings: RouteSettings(name: routeName),
    screen: screen,
  );
}

Future<void> pushNewScreenWithoutNavBar(context, screen, routeName) async {
  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
    context,
    withNavBar: false,
    settings: RouteSettings(name: routeName),
    screen: screen,
  );
}
