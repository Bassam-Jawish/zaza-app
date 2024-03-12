import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/core/widgets/custom_toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaza_app/features/product/presentation/widgets/product_card.dart';

import '../../../../core/app_export.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../injection_container.dart';
import '../../../product/presentation/widgets/shimmer_products_loading.dart';
import '../bloc/discount_bloc.dart';

class DiscountBody extends StatelessWidget {
  DiscountBody(this.state, {super.key});

  DiscountState state;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return state.isDiscountHomeLoaded!
        ? RefreshIndicator(
            onRefresh: () async {
              context.read<DiscountBloc>().add(
                  GetAllDiscountProducts(limit, 0, sort, languageCode, true));
              await Future.delayed(Duration(seconds: 2));
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: state.scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03, vertical: height * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColor.secondaryLight,
                            size: 20,
                          ),
                          iconSize: 20,
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.number_of_Products} (${state.productAllDiscountEntity!.totalNumber})',
                          style: TextStyle(
                              color: theme.secondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp),
                        ),
                        sort == 'newest'
                            ? Text(
                                '(${AppLocalizations.of(context)!.newest})',
                                style: TextStyle(
                                    color: theme.primary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.sp),
                              )
                            : Text(
                                '(${AppLocalizations.of(context)!.oldest})',
                                style: TextStyle(
                                    color: theme.primary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.sp),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.025,
                    ),
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
                        if (index < state.productDiscountList!.length) {
                          return ProductCard(
                              index,
                              state.productDiscountList![index].productId!,
                              state.productDiscountList![index].productName!,
                              state.productDiscountList![index].image!,
                              state.productDiscountList![index].barCode!,
                              state.productDiscountList![index].discount!,
                              state.productDiscountList![index]
                                  .productUnitListModel![0].productUnitId!,
                              state.productDiscountList![index]
                                  .productUnitListModel![0].unitName!,
                              state.productDiscountList![index]
                                  .productUnitListModel![0].description!,
                              0,
                              state.productDiscountList![index]
                                  .productUnitListModel![0].quantity!,
                              4,
                              state.productDiscountList![index]
                                  .productUnitListModel![0].price!,
                              state);
                        }
                      },
                      itemCount:
                          state.discountStatus == DiscountStatus.paginated
                              ? state.productDiscountList!.length
                              : state.productDiscountList!.length + 1,
                    ),
                    state.discountStatus == DiscountStatus.paginated
                        ? Center(child: SpinKitApp(width))
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          )
        : ShimmerProductsLoading();
  }
}
