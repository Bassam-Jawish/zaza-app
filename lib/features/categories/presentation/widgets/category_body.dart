import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/config/theme/styles.dart';
import 'package:zaza_app/features/categories/presentation/widgets/category_card.dart';
import 'package:zaza_app/features/categories/presentation/widgets/shimmer_sub_cat_loading.dart';
import 'package:zaza_app/features/categories/presentation/widgets/sub_category_card.dart';
import 'package:zaza_app/features/product/presentation/widgets/product_card.dart';

import '../../../../core/utils/functions/spinkit.dart';
import '../../../../injection_container.dart';
import '../../../product/presentation/widgets/shimmer_products_loading.dart';
import '../bloc/category_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryBody extends StatelessWidget {
  const CategoryBody(this.state, {super.key});

  final CategoryState state;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return state.screenType == 'root'
        ? rootWidget(context, width, height, state)
        : state.screenType == 'unknown'
            ? unknownWidget(context, width, height, state)
            : state.screenType == 'node'
                ? categoryNodeWidget(context, width, height, state)
                : state.screenType == 'leaf'
                    ? categoryLeafWidget(context, width, height, state)
                    : ShimmerProductsLoading();
  }

  Widget rootWidget(context, width, height, CategoryState state) {
    return ConditionalBuilder(
      condition: state.isPageLoaded!,
      builder: (context) => RefreshIndicator(
        onRefresh: () async {
          context.read<CategoryBloc>().add(
              GetCategoryChildren(categoryId, 0, limit, languageCode, true));
          await Future.delayed(Duration(seconds: 2));
        },
        child: SingleChildScrollView(
          controller: state.scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.category,
                        color: AppColor.secondaryLight,
                        size: 20.sp,
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.main_Categories}  (${state.chooseTypeEntity!.totalNumber})',
                        style: Styles.textStyle20.copyWith(
                          color: AppColor.secondaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: width * 0.5,
                      mainAxisExtent: height * 0.32,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: state.categoryStatus == CategoryStatus.paginated
                        ? state.categoriesPaginated!.length
                        : state.categoriesPaginated!.length + 1,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      /*String path =
                                '${url}${state.productsModel!.productsListChildren![index].image}';*/
                      //print(path);
                      if (index < state.categoriesPaginated!.length) {
                        return CategoryCard(
                            state.categoriesPaginated![index].id!,
                            state.categoriesPaginated![index].categoryName!,
                            state.categoriesPaginated![index].image!,
                            state.categoriesPaginated![index].itemsNumber!);
                      }

                      /*buildCategoryCard(
                          width,
                          height,
                          context,
                          state,
                          state.rootModel!.categoriesChildren![index].id!,
                          state.rootModel!.categoriesChildren![index].categoryName!,
                          state.rootModel!.categoriesChildren![index].image!,
                          state.rootModel!.categoriesChildren![index].itemsNumber!,
                        );*/
                    },
                  ),
                  state.categoryStatus == CategoryStatus.paginated
                      ? Center(child: SpinKitApp(width))
                      : SizedBox(),
                ],
              )),
        ),
      ),
      fallback: (context) => ShimmerProductsLoading(),
    );
  }

  Widget unknownWidget(context, width, height, CategoryState state) {
    return ConditionalBuilder(
      condition: state.isPageLoaded!,
      builder: (context) => Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              iconSize: 20,
            ),
            Text(
              '${AppLocalizations.of(context)!.nothing_Found}',
              style: TextStyle(
                  color: AppColor.secondaryLight,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      fallback: (context) => ShimmerProductsLoading(),
    );
  }

  Widget categoryNodeWidget(context, width, height, CategoryState state) {
    return ConditionalBuilder(
      condition: state.isPageLoaded!,
      builder: (context) => SingleChildScrollView(
        controller: state.scrollController,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  SizedBox(
                    width: 280.w,
                    child: Text(
                      '${state.categoryParentEntity!.categoryParentName}   (${state.chooseTypeEntity!.totalNumber})',
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: AppColor.secondaryLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.025,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.categoriesPaginated!.length,
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: height * 0.02,
                ),
                itemBuilder: (context, index) {
                  if (index < state.categoriesPaginated!.length) {
                    return SubCategoryCard(
                        state.categoriesPaginated![index].id!,
                        state.categoriesPaginated![index].categoryName!,
                        state.categoriesPaginated![index].image!,
                        state.categoriesPaginated![index].itemsNumber!);
                  }
                },
              ),
              state.categoryStatus == CategoryStatus.paginated
                  ? Center(child: SpinKitApp(width))
                  : SizedBox(),
            ],
          ),
        ),
      ),
      fallback: (context) => ShimmerSubCatLoading(),
    );
  }

  Widget categoryLeafWidget(context, width, height, CategoryState state) {
    var theme = Theme.of(context).colorScheme;
    return ConditionalBuilder(
      condition: state.isPageLoaded!,
      builder: (context) => SingleChildScrollView(
        controller: state.scrollController,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  SizedBox(
                    width: 280.w,
                    child: Text(
                      '${state.categoryParentEntity!.categoryParentName}  (${state.chooseTypeEntity!.totalNumber})',
                      style: TextStyle(
                        color: AppColor.secondaryLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Spacer(),
                  /*sort == 'newest'
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
                  ),*/
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
                  if (index < state.productsPaginated!.length) {
                    return ProductCard(
                        index,
                        state.productsPaginated![index].productId!,
                        state.productsPaginated![index].productName!,
                        state.productsPaginated![index].image!,
                        state.productsPaginated![index].barCode!,
                        state.productsPaginated![index].discount!,
                        state.productsPaginated![index].productUnitListModel![0]
                            .productUnitId!,
                        state.productsPaginated![index].productUnitListModel![0]
                            .unitName!,
                        state.productsPaginated![index].productUnitListModel![0]
                            .description!,
                        0,
                        state.productsPaginated![index].productUnitListModel![0]
                            .quantity!,
                        6,
                        state.productsPaginated![index].productUnitListModel![0]
                            .price!,
                        state);
                  }
                },
                itemCount: state.categoryStatus == CategoryStatus.paginated
                    ? state.productsPaginated!.length + 1
                    : state.productsPaginated!.length,
              ),
              state.categoryStatus == CategoryStatus.paginated
                  ? Center(child: SpinKitApp(width))
                  : SizedBox(),
            ],
          ),
        ),
      ),
      fallback: (context) => ShimmerProductsLoading(),
    );
  }
}
