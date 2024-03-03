import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../widgets/bottom_navigation_bar.dart';

class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  //final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentBottomNavigationBar(),
    );
  }
}
