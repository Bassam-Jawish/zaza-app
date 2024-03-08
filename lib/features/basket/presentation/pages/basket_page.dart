import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/core/widgets/custom_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaza_app/features/product/presentation/bloc/new_product/new_product_bloc.dart';

import '../../../../core/widgets/custom_floating.dart';
import '../../../../injection_container.dart';
import '../widgets/basket_body.dart';

class BasketPage extends StatelessWidget {
  const BasketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: theme.background,
        appBar: CustomAppBar(AppLocalizations.of(context)!.basket, width, height, context, true, true),
        body: BasketBody(),
      ),
    );
  }
}
