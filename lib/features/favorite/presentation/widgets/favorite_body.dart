import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/core/widgets/custom_toast.dart';

import '../../../../core/app_export.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../injection_container.dart';
import '../../../product/presentation/widgets/product_card.dart';
import '../bloc/favorite_bloc.dart';

class FavoriteBody extends StatelessWidget {
  const FavoriteBody({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider<FavoriteBloc>(
      create: (context) =>
          sl()..add(GetFavoriteProducts(limit, 0, sort, '', languageCode)),
      child: BlocConsumer<FavoriteBloc, FavoriteState>(
        listener: (context, state) {
          if (state.favoriteStatus == FavoriteStatus.error) {
            showToast(text: state.error!.message, state: ToastState.error);
          }
          if (state.favoriteStatus == FavoriteStatus.paginated) {
            context.read<FavoriteBloc>()
              ..add(GetFavoriteProducts(
                  limit, state.favoriteCurrentIndex!, sort, '', languageCode));
          }
        },
        builder: (context, state) {
          return !state.isFirst!
              ? SingleChildScrollView(
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
                            Text(
                              '${AppLocalizations.of(context)!.number_of_Products} (${state.favoriteProductsList!.length})',
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
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: width * 0.5,
                            mainAxisExtent: height * 0.36,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index < state.favoriteProductsList!.length) {
                              return ProductCard(
                                  index,
                                  state.favoriteProductsList![index].productId!,
                                  state.favoriteProductsList![index]
                                      .productName!,
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
                )
              : SpinKitApp(width);
        },
      ),
    );
  }
}
