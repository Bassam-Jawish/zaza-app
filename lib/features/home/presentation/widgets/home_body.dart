import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/core/widgets/custom_toast.dart';
import 'package:zaza_app/features/discount/presentation/bloc/discount_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaza_app/features/discount/presentation/pages/discount_page.dart';
import 'package:zaza_app/features/home/presentation/widgets/discount_card.dart';
import 'package:zaza_app/features/product/presentation/widgets/product_card.dart';
import 'package:zaza_app/injection_container.dart';

import '../../../../core/utils/functions/spinkit.dart';
import '../../../base/presentation/widgets/push_bottom_bar.dart';
import '../../../product/presentation/bloc/product/product_bloc.dart';
import '../../../product/presentation/pages/new_products_page.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {

  @override
  void initState() {
    BlocProvider.of<DiscountBloc>(context).add(GetHomeDiscountProducts(limit, 0, sort, languageCode));
    BlocProvider.of<BasketBloc>(context).add((GetIdQuantityForBasket()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MultiBlocListener(
        listeners: [
          BlocListener<DiscountBloc, DiscountState>(
            listener: (context, state) {
              if (state.discountStatus == DiscountStatus.error) {
                showToast(text: state.error!.message, state: ToastState.error);
              }
              if (state.discountStatus == DiscountStatus.success) {
                context.read<ProductBloc>().add(GetHomeNewProducts(
                    limitForProductsInHome, 0, 'newest', '', languageCode));
              }
            },
          ),
          BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state.productStatus == ProductStatus.errorHomeNewProducts) {
                showToast(text: state.error!.message, state: ToastState.error);
              }
            },
          ),
        ],
        child: Builder(builder: (context) {
          final state = context.watch<DiscountBloc>().state;
          final stateNewProducts = context.watch<ProductBloc>().state;
          return state.isDiscountHomeLoaded! ? stateNewProducts.isNewHomeLoaded!
              ? RefreshIndicator(
                  onRefresh: () async {
                    context.read<DiscountBloc>().add(GetHomeDiscountProducts(
                        limit, 0, 'newest', languageCode));
                    await Future.delayed(Duration(seconds: 2));
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.03, vertical: height * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.hello(user_name),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 30.sp),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.discount,
                                    color: theme.secondary,
                                    size: 20.sp,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .discount_Items,
                                    style: TextStyle(
                                        color: theme.secondary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20.sp),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  pushNewScreenWithNavBar(
                                      context, DiscountPage(), '/discount');
                                },
                                style: ButtonStyle(
                                  overlayColor: MaterialStateColor.resolveWith(
                                      (states) => AppColor.shadeColor),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.see_All,
                                  style: TextStyle(
                                    color: theme.secondary,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.25,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02),
                              itemBuilder: (context, index) =>
                                  BuildDiscountProductCard(
                                      state.productEntityHome!
                                          .productList![index].productId!,
                                      state.productEntityHome!
                                          .productList![index].productName!,
                                      state.productEntityHome!
                                          .productList![index].image!,
                                      state.productEntityHome!
                                          .productList![index].barCode!,
                                      state.productEntityHome!
                                          .productList![index].discount!,
                                      state
                                          .productEntityHome!
                                          .productList![index]
                                          .productUnitListModel![0]
                                          .productUnitId!,
                                      state
                                          .productEntityHome!
                                          .productList![index]
                                          .productUnitListModel![0]
                                          .description!,
                                      0,
                                      state
                                          .productEntityHome!
                                          .productList![index]
                                          .productUnitListModel![0]
                                          .quantity!,
                                      state
                                          .productEntityHome!
                                          .productList![index]
                                          .productUnitListModel![0]
                                          .unitName!,
                                      state
                                          .productEntityHome!
                                          .productList![index]
                                          .productUnitListModel![0]
                                          .price!),
                              itemCount:
                                  state.productEntityHome!.productList!.length,
                              separatorBuilder: (context, index) => SizedBox(
                                width: width * 0.04,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.production_quantity_limits,
                                    color: theme.secondary,
                                    size: 20.sp,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.new_Items,
                                    style: TextStyle(
                                        color: theme.secondary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20.sp),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  pushNewScreenWithNavBar(context,
                                      NewProductsPage(), '/new-products');
                                },
                                style: ButtonStyle(
                                  overlayColor: MaterialStateColor.resolveWith(
                                      (states) => AppColor.shadeColor),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.see_All,
                                  style: TextStyle(
                                    color: theme.secondary,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: width * 0.5,
                              mainAxisExtent: height * 0.36,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ProductCard(
                                  index,
                                  stateNewProducts.homeNewProductsEntity!
                                      .productList![index].productId!,
                                  stateNewProducts.homeNewProductsEntity!
                                      .productList![index].productName!,
                                  stateNewProducts.homeNewProductsEntity!
                                      .productList![index].image!,
                                  stateNewProducts.homeNewProductsEntity!
                                      .productList![index].barCode!,
                                  stateNewProducts.homeNewProductsEntity!
                                      .productList![index].discount!,
                                  stateNewProducts
                                      .homeNewProductsEntity!
                                      .productList![index]
                                      .productUnitListModel![0]
                                      .productUnitId!,
                                  stateNewProducts
                                      .homeNewProductsEntity!
                                      .productList![index]
                                      .productUnitListModel![0]
                                      .unitName!,
                                  stateNewProducts
                                      .homeNewProductsEntity!
                                      .productList![index]
                                      .productUnitListModel![0]
                                      .description!,
                                  0,
                                  stateNewProducts
                                      .homeNewProductsEntity!
                                      .productList![index]
                                      .productUnitListModel![0]
                                      .quantity!,
                                  0,
                                  stateNewProducts
                                      .homeNewProductsEntity!
                                      .productList![index]
                                      .productUnitListModel![0]
                                      .price!,
                                  stateNewProducts);
                            },
                            itemCount: stateNewProducts
                                .homeNewProductsEntity!.productList!.length,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SpinKitApp(width) : SpinKitApp(width);
        }));
  }
}
