import 'package:flutter/material.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaza_app/features/product/presentation/widgets/custom_product_appbar.dart';

import '../widgets/profile_body.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.background,
        appBar:CustomProductAppBar(AppLocalizations.of(context)!.profile, width, height, context, true),
      //appBar: CustomAppBar(AppLocalizations.of(context)!.profile, width, height, context, false,false),
      body: ProfileBody(),
    );
  }
}
