import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/core/widgets/custom_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaza_app/features/product/presentation/widgets/custom_product_appbar.dart';

import '../../../../core/widgets/custom_floating.dart';
import '../../../../core/widgets/custom_toast.dart';
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
          sl()..add(GetAllDiscountProducts(limit, 0, sort, languageCode, true)),
      child: BlocConsumer<DiscountBloc, DiscountState>(
        listener: (context, state) {
          if (state.discountStatus == DiscountStatus.changeSort) {
            context
                .read<DiscountBloc>()
                .add(GetAllDiscountProducts(limit, 0, sort, languageCode, true));
          }
          if (state.discountStatus == DiscountStatus.errorAllDiscount) {
            showToast(text: state.error!.message, state: ToastState.error);
          }

          if (state.discountStatus == DiscountStatus.paginated) {
            context
                .read<DiscountBloc>()
                .add(GetAllDiscountProducts(limit, state.discountCurrentIndex!, sort, languageCode, false));
          }

        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.background,
            //appBar: null,
            appBar: CustomProductAppBar(AppLocalizations.of(context)!.hot_Deals, width, height, context, false),
            body: DiscountBody(state),
            floatingActionButton:
                sortFloatingButton('DiscountBloc', context, () {
              context.read<DiscountBloc>().add(ChangeSortDiscount());
            }),
          );
        },
      ),
    );
  }
}
