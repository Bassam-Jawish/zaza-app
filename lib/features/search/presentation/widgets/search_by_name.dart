import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:zaza_app/features/search/presentation/widgets/shimmer_search_loading.dart';

import '../../../../core/app_export.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/default_textformfield.dart';
import '../../../../injection_container.dart';
import '../../../product/presentation/widgets/product_card.dart';
import 'no_search.dart';
import 'no_search_found.dart';
import 'package:easy_debounce/easy_debounce.dart';

class SearchByName extends StatelessWidget {
  SearchByName(this.state, this.searchByProductNameController, {super.key});

  final ProductState state;

  TextEditingController searchByProductNameController;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      controller: state.scrollControllerSearchName,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.01, vertical: height * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            def_TextFromField_search(
              keyboardType: TextInputType.text,
              controller: searchByProductNameController,
              onChanged: (value) {
                EasyDebounce.debounce(
                    'my-debouncer',
                    const Duration(milliseconds: 500),
                        () => context.read<ProductBloc>()
                ..add(GetSearchNameProducts(
                limitSearch, 0, 'newest', value, languageCode, true)));
              },
              br: 15,
              label: '${AppLocalizations.of(context)!.search_By_Product_Name}',
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
              condition: state.isFirstSearchName!,
              builder: (context) => ConditionalBuilder(
                condition: state.isSearchByNameLoaded!,
                builder: (context) => ConditionalBuilder(
                  condition: state.productSearchNameList!.isNotEmpty,
                  builder: (context) => Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: width * 0.5,
                          mainAxisExtent: height * 0.4,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index < state.productSearchNameList!.length) {
                            return ProductCard(
                                index,
                                state.productSearchNameList![index].productId!,
                                state
                                    .productSearchNameList![index].productName!,
                                state.productSearchNameList![index].image!,
                                state.productSearchNameList![index].barCode!,
                                state.productSearchNameList![index].discount!,
                                state.productSearchNameList![index]
                                    .productUnitListModel![0].productUnitId!,
                                state.productSearchNameList![index]
                                    .productUnitListModel![0].unitName!,
                                state.productSearchNameList![index]
                                    .productUnitListModel![0].description!,
                                0,
                                state.productSearchNameList![index]
                                    .productUnitListModel![0].quantity!,
                                2,
                                state.productSearchNameList![index]
                                    .productUnitListModel![0].price!,
                                state);
                          }
                        },
                        itemCount: state.productStatus ==
                                ProductStatus.loadingNameSearchPaginated
                            ? state.productSearchNameList!.length
                            : state.productSearchNameList!.length + 1,
                      ),
                      state.productStatus ==
                              ProductStatus.loadingNameSearchPaginated
                          ? Center(child: SpinKitApp(width))
                          : SizedBox(),
                    ],
                  ),
                  fallback: (context) => NoSearchFound(context),
                ),
                fallback: (context) => ShimmerSearchLoading(),
              ),
              fallback: (context) => NoSearchYet(height, context),
            ),
          ],
        ),
      ),
    );
  }
}
