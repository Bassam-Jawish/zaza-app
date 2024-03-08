import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/core/widgets/custom_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaza_app/features/product/presentation/bloc/new_product/new_product_bloc.dart';

import '../../../../core/widgets/custom_floating.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../injection_container.dart';
import '../widgets/new_products_body.dart';

class NewProductsPage extends StatelessWidget {
  const NewProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider<NewProductBloc>(
  create: (context) => sl()..add(GetAllNewProducts(limit, 0, 'newest', '', languageCode, true)),
  child: BlocConsumer<NewProductBloc, NewProductState>(
      listener: (context, state) {
        if (state.newProductStatus == NewProductStatus.changeSort) {
          context
              .read<NewProductBloc>()
              .add(GetAllNewProducts(limit, 0, 'newest', '', languageCode, true));
        }
        if (state.newProductStatus == NewProductStatus.errorAllNewProducts) {
          showToast(text: state.error!.message, state: ToastState.error);
        }

        if (state.newProductStatus ==
            NewProductStatus.loadingAllNewProductsPaginated) {
          context
              .read<NewProductBloc>()
              .add(GetAllNewProducts(limit, state.newProductsCurrentIndex!, 'newest', '', languageCode, false));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.background,
          appBar: null,
          //appBar: CustomAppBar(AppLocalizations.of(context)!.new_Products, width, height, context, true, false),
          body: NewProductsBody(state),
          /*floatingActionButton:
              sortFloatingButton('NewProductBloc', context, () {
            context.read<NewProductBloc>().add(ChangeSortNewProducts());
          }),*/
        );
      },
    ),
);
  }
}
