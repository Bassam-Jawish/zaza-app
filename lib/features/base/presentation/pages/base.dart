import 'package:flutter/material.dart';

import '../widgets/bottom_navigation_bar.dart';

class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  //final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        /*body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          //child: navigationShell,
        ),*/
        body: PersistentBottomNavigationBar());
  }
}
