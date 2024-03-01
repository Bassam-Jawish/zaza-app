import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/core/widgets/custom_toast.dart';
import 'package:zaza_app/features/discount/presentation/bloc/discount_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaza_app/features/home/presentation/widgets/discount_card.dart';
import 'package:zaza_app/injection_container.dart';

import '../../../../core/utils/functions/spinkit.dart';
import '../../../base/presentation/widgets/push_bottom_bar.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

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
            },
          ),
        ],
        child: Builder(builder: (context) {
          final state = context.watch<DiscountBloc>().state;
          return state.discountStatus == DiscountStatus.success
              ? RefreshIndicator(
                  onRefresh: () async {
                    context.read<DiscountBloc>().add(GetHomeDiscountProducts(
                        limit, 0, 'newest', languageCode));
                    await Future.delayed(Duration(seconds: 2));
                  },
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03, vertical: height * 0.03),
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
                                  AppLocalizations.of(context)!.discount_Items,
                                  style: TextStyle(
                                      color: theme.secondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.sp),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                /*pushNewScreenWithNavBar(
                        context,
                        DiscountProductsScreen(),
                        '/discount-products');*/
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
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.02),
                            itemBuilder: (context, index) =>
                                BuildDiscountProductCard(
                                    state.productEntityHome!.productList![index]
                                        .productId!,
                                    state.productEntityHome!.productList![index]
                                        .productName!,
                                    state.productEntityHome!.productList![index]
                                        .image!,
                                    state.productEntityHome!.productList![index]
                                        .barCode!,
                                    state.productEntityHome!.productList![index]
                                        .discount!,
                                    state
                                        .productEntityHome!
                                        .productList![index]
                                        .productUnitListModel![0]
                                        .productUnitId!,
                                    state.productEntityHome!.productList![index]
                                        .productUnitListModel![0].description!,
                                    0,
                                    state.productEntityHome!.productList![index]
                                        .productUnitListModel![0].quantity!,
                                    state.productEntityHome!.productList![index]
                                        .productUnitListModel![0].unitName!,
                                    state.productEntityHome!.productList![index]
                                        .productUnitListModel![0].price!),
                            itemCount:
                                state.productEntityHome!.productList!.length,
                            separatorBuilder:
                                (BuildContext context, int index) => SizedBox(
                              height: 10.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                )
              : SpinKitApp(width);
        }));
  }
}
