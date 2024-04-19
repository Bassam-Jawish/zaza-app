import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/core/widgets/custom_toast.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/app_export.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../injection_container.dart';
import '../../../product/presentation/widgets/product_card.dart';
import '../../../product/presentation/widgets/shimmer_products_loading.dart';
import '../bloc/favorite_bloc.dart';

class FavoriteBody extends StatelessWidget {
  const FavoriteBody(this.state, {super.key});

  final FavoriteState state;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return state.isFavoriteLoaded!
        ? RefreshIndicator(
            onRefresh: () async {
              context.read<FavoriteBloc>().add(
                  GetFavoriteProducts(limit, 0, sort, '', languageCode, true));
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
                            size: 20.sp,
                          ),
                          iconSize: 20.sp,
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.number_of_Products} (${state.favoriteProductsEntity!.totalNumber})',
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
                        mainAxisExtent: height * 0.4,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index < state.favoriteProductsList!.length) {
                          return ProductCard(
                              index,
                              state.favoriteProductsList![index].productId!,
                              state.favoriteProductsList![index].productName!,
                              state.favoriteProductsList![index].image!,
                              state.favoriteProductsList![index].barCode!,
                              state.favoriteProductsList![index].discount!,
                              state.favoriteProductsList![index]
                                  .productUnitListModel![0].productUnitId!,
                              state.favoriteProductsList![index]
                                  .productUnitListModel![0].unitName!,
                              state.favoriteProductsList![index]
                                  .productUnitListModel![0].description!,
                              0,
                              state.favoriteProductsList![index]
                                  .productUnitListModel![0].quantity!,
                              3,
                              state.favoriteProductsList![index]
                                  .productUnitListModel![0].price!,
                              state);
                        }
                      },
                      itemCount:
                          state.favoriteStatus == FavoriteStatus.paginated
                              ? state.favoriteProductsList!.length
                              : state.favoriteProductsList!.length + 1,
                    ),
                    state.favoriteStatus == FavoriteStatus.paginated
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
