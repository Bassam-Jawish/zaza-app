import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../widgets/settings_body.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.background,
      appBar: CustomAppBar(AppLocalizations.of(context)!.more, width, height, context, true),
      body: SettingsBody(),
    );
  }
}
