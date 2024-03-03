import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/core/widgets/custom_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/widgets/custom_floating.dart';
import '../../../../injection_container.dart';
import '../bloc/discount_bloc.dart';
import '../widgets/discount_body.dart';

class DiscountPage extends StatelessWidget {
  const DiscountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider<DiscountBloc>(
      create: (BuildContext context) =>
          sl()..add(GetAllDiscountProducts(limit, 0, sort, languageCode)),
      child: Scaffold(
        backgroundColor: theme.background,
        appBar: CustomAppBar(
            AppLocalizations.of(context)!.hot_Deals, width, height, context, true),
        body: DiscountBody(),
        floatingActionButton: sortFloatingButton('DiscountBloc', context, () {
          context.read<DiscountBloc>().add(ChangeSortDiscount());
        }),
      ),
    );
  }
}
