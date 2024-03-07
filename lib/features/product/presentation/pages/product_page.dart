import 'package:flutter/material.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/features/basket/presentation/widgets/quantity_dialog.dart';

import '../../../../core/app_export.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../injection_container.dart';
import '../bloc/product/product_bloc.dart';
import '../widgets/product_body.dart';

class ProductPage extends StatelessWidget {
  ProductPage({Key? key}) : super(key: key);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider<ProductBloc>(
      create: (BuildContext context) =>
      sl()..add(GetProductProfile(productId, languageCode)),
      child: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state.productStatus == ProductStatus.errorProductProfile) {
            showToast(text: state.error!.message, state: ToastState.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.background,
            appBar: CustomAppBar(AppLocalizations.of(context)!.item_Details,
                width, height, context, false),
            body: ProductBody(state),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                quantityDialog(
                    width,
                    height,
                    context,
                    state.productProfile!
                        .productUnitListModel![state.unitIndex!].quantity!,
                    formKey,
                    state.productProfile!.productId!,
                    state.productProfile!
                        .productUnitListModel![state.unitIndex!].productUnitId!);
              },
              elevation: 0.0,
              label: Text(
                'ADD TO BASKET',
              ),
              icon: Icon(Icons.add),
              backgroundColor: AppColor.primaryLight,
              foregroundColor: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
