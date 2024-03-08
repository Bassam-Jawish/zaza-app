import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:zaza_app/injection_container.dart';

import '../../../../core/app_export.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/default_textformfield.dart';
import '../../../product/presentation/widgets/product_card.dart';
import 'no_search.dart';
import 'no_search_found.dart';

class SearchByBarcode extends StatelessWidget {
  SearchByBarcode(this.state, this.searchByBarcodeController, {super.key});

  final ProductState state;

  TextEditingController searchByBarcodeController;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      controller: state.scrollControllerSearchBarcode,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            def_TextFromField_search(
              keyboardType: TextInputType.number,
              controller: searchByBarcodeController,
              onChanged: (value) {
                context.read<ProductBloc>()
                  ..add(GetSearchBarcodeProducts(
                      limitSearch, 0, 'newest', value, languageCode, true));
              },
              br: 15,
              label: '${AppLocalizations.of(context)!.search_By_Product_Id}',
              labelStyle: TextStyle(color: theme.primary, fontSize: 14.sp),
              prefixIcon: Icon(
                Icons.search,
                color: theme.primary,
                size: 25.sp,
              ),
            ),
            SizedBox(
              height: height * 0.06,
            ),
            ConditionalBuilder(
              condition: state.isFirstSearchBarcode!,
              builder: (context) => ConditionalBuilder(
                condition: state.isSearchByBarcodeLoaded!,
                builder: (context) => ConditionalBuilder(
                  condition: state.productSearchBarcodeList!.isNotEmpty,
                  builder: (context) => Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: width * 0.5,
                          mainAxisExtent: height * 0.36,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index < state.productSearchBarcodeList!.length) {
                            return ProductCard(
                                index,
                                state.productSearchBarcodeList![index]
                                    .productId!,
                                state.productSearchBarcodeList![index]
                                    .productName!,
                                state.productSearchBarcodeList![index].image!,
                                state.productSearchBarcodeList![index].barCode!,
                                state
                                    .productSearchBarcodeList![index].discount!,
                                state.productSearchBarcodeList![index]
                                    .productUnitListModel![0].unitId!,
                                state.productSearchBarcodeList![index]
                                    .productUnitListModel![0].unitName!,
                                state.productSearchBarcodeList![index]
                                    .productUnitListModel![0].description!,
                                0,
                                state.productSearchBarcodeList![index]
                                    .productUnitListModel![0].quantity!,
                                1,
                                state.productSearchBarcodeList![index]
                                    .productUnitListModel![0].price!,
                                state);
                          }
                        },
                        itemCount: state.productStatus ==
                                ProductStatus.loadingBarcodeSearchPaginated
                            ? state.productSearchBarcodeList!.length
                            : state.productSearchBarcodeList!.length + 1,
                      ),
                      state.productStatus ==
                              ProductStatus.loadingBarcodeSearchPaginated
                          ? Center(child: SpinKitApp(width))
                          : SizedBox(),
                    ],
                  ),
                  fallback: (context) => NoSearchFound(context),
                ),
                fallback: (context) => SpinKitApp(width),
              ),
              fallback: (context) => NoSearchYet(height, context),
            ),
          ],
        ),
      ),
    );
  }
}
