import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/features/product/presentation/widgets/custom_product_appbar.dart';

import '../../../../core/app_export.dart';
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
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state.productStatus == ProductStatus.errorProductProfile) {
                showToast(text: state.error!.message, state: ToastState.error);
              }
            },
          ),
          BlocListener<BasketBloc, BasketState>(
            listener: (context, state) {},
          ),
        ],
        child: Builder(builder: (context) {
          final state1 = context.watch<BasketBloc>().state;
          final state2 = context.watch<ProductBloc>().state;
          return Scaffold(
            backgroundColor: theme.background,
            appBar: CustomProductAppBar(
                AppLocalizations.of(context)!.item_Details,
                width,
                height,
                context,
                true),
            body: ProductBody(state2, formKey),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  onPressed: () async {
                    if (state1.quantityMap![state2
                            .productProfile!
                            .productUnitListModel![state2.unitIndex!]
                            .productUnitId] !=
                        null) {
                      if (state1.quantityMap![state2
                              .productProfile!
                              .productUnitListModel![state2.unitIndex!]
                              .productUnitId] !=
                          0) {
                        context.read<BasketBloc>().add(AddToBasket(
                            state2
                                .productProfile!
                                .productUnitListModel![state2.unitIndex!]
                                .productUnitId!,
                            state1.quantityMap![state2
                                .productProfile!
                                .productUnitListModel![state2.unitIndex!]
                                .productUnitId]! - 1));
                      }
                    }
                  },
                  elevation: 0.0,
                  label: Text(
                    'DELETE ONE',
                  ),
                  icon: Icon(Icons.exposure_minus_1),
                  backgroundColor: AppColor.primaryLight,
                  foregroundColor: Colors.white,
                ),
                SizedBox(
                  width: 10.w,
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    if (state1.quantityMap![state2
                            .productProfile!
                            .productUnitListModel![state2.unitIndex!]
                            .productUnitId!] ==
                        null) {
                      context.read<BasketBloc>().add(AddToBasket(
                          state2
                              .productProfile!
                              .productUnitListModel![state2.unitIndex!]
                              .productUnitId!,
                          1));
                    } else {
                      if (state1.quantityMap![state2
                              .productProfile!
                              .productUnitListModel![state2.unitIndex!]
                              .productUnitId!] <
                          state2
                              .productProfile!
                              .productUnitListModel![state2.unitIndex!]
                              .quantity!) {
                        context.read<BasketBloc>().add(AddToBasket(
                            state2
                                .productProfile!
                                .productUnitListModel![state2.unitIndex!]
                                .productUnitId!,
                            state1.quantityMap![state2
                                    .productProfile!
                                    .productUnitListModel![state2.unitIndex!]
                                    .productUnitId]! +
                                1));
                      }
                    }
                  },
                  elevation: 0.0,
                  label: Text(
                    'ADD TO BASKET',
                  ),
                  icon: Icon(Icons.plus_one),
                  backgroundColor: AppColor.primaryLight,
                  foregroundColor: Colors.white,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
