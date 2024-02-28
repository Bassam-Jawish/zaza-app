import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/core/widgets/custom_toast.dart';
import 'package:zaza_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:zaza_app/features/categories/presentation/widgets/category_card.dart';
import 'package:zaza_app/features/categories/presentation/widgets/sub_category_card.dart';
import 'package:zaza_app/features/product/presentation/widgets/product_card.dart';

import '../../../../core/utils/functions/spinkit.dart';
import '../../../../injection_container.dart';
import '../bloc/category_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryBody extends StatelessWidget {
  const CategoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider<CategoryBloc>(
      create: (BuildContext context) =>
          sl()..add(GetCategoryChildren(categoryId, 0, limit, languageCode)),
      child: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state.categoryStatus == CategoryStatus.error) {
            showToast(text: state.error!.message, state: ToastState.error);
          }
        },
        builder: (context, state) {
          return state.screenType == 'root'
              ? rootWidget(context, width, height, state)
              : state.screenType == 'unknown'
                  ? unknownWidget(context, width, height, state)
                  : state.screenType == 'node'
                      ? categoryNodeWidget(context, width, height, state)
                      : state.screenType == 'leaf'
                          ? categoryLeafWidget(context, width, height, state)
                          : SpinKitApp(width);
        },
      ),
    );
  }

  Widget rootWidget(context, width, height, CategoryState state) {
    return ConditionalBuilder(
      condition: state.categoryParentEntity != null,
      builder: (context) => RefreshIndicator(
        onRefresh: () async {
          context
              .read<CategoryBloc>()
              .add(GetCategoryChildren(categoryId, 0, limit, languageCode));
          await Future.delayed(Duration(seconds: 2));
        },
        child: SingleChildScrollView(
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
                        style: TextStyle(
                            color: AppColor.secondaryLight,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp),
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
                    itemCount:
                        state.categoryParentEntity!.categoriesChildren!.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      /*String path =
                              '${url}${state.productsModel!.productsListChildren![index].image}';*/
                      //print(path);
                      return CategoryCard(
                          state.categoryParentEntity!.categoriesChildren![index]
                              .id!,
                          state.categoryParentEntity!.categoriesChildren![index]
                              .categoryName!,
                          state.categoryParentEntity!.categoriesChildren![index]
                              .image!,
                          state.categoryParentEntity!.categoriesChildren![index]
                              .itemsNumber!);

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
                ],
              )),
        ),
      ),
      fallback: (context) => SpinKitApp(width),
    );
  }

  Widget unknownWidget(context, width, height, CategoryState state) {
    return ConditionalBuilder(
      condition: state.unknownChildEntity != null,
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
                Icons.arrow_back_outlined,
                color: AppColor.secondaryLight,
                size: 20.sp,
              ),
              iconSize: 20.sp,
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
      fallback: (context) => SpinKitApp(width),
    );
  }

  Widget categoryNodeWidget(context, width, height, CategoryState state) {
    return ConditionalBuilder(
      condition: state.categoryParentEntity != null,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      color: AppColor.secondaryLight,
                      size: 20.sp,
                    ),
                    iconSize: 20.sp,
                  ),
                  Text(
                    '${state.categoryParentEntity!.categoryParentName}  (${state.chooseTypeEntity!.totalNumber})',
                    style: TextStyle(
                        color: AppColor.secondaryLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.025,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    state.categoryParentEntity!.categoriesChildren!.length,
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: height * 0.02,
                ),
                itemBuilder: (context, index) => SubCategoryCard(
                    state.categoryParentEntity!.categoriesChildren![index].id!,
                    state.categoryParentEntity!.categoriesChildren![index]
                        .categoryName!,
                    state.categoryParentEntity!.categoriesChildren![index]
                        .image!,
                    state.categoryParentEntity!.categoriesChildren![index]
                        .itemsNumber!),
              ),
            ],
          ),
        ),
      ),
      fallback: (context) => SpinKitApp(width),
    );
  }

  Widget categoryLeafWidget(context, width, height, CategoryState state) {
    return ConditionalBuilder(
      condition: state.categoryParentEntity != null,
      builder: (context) => SingleChildScrollView(
        controller: state.scrollController,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                    '${state.categoryParentEntity!.categoryParentName}  (${state.chooseTypeEntity!.totalNumber})',
                    style: TextStyle(
                        color: AppColor.secondaryLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp),
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
                  if (index < state.productsPaginated!.length) {
                    return ProductCard(
                      index,
                      state.productsPaginated![index].productId!,
                      state.productsPaginated![index].productName!,
                      state.productsPaginated![index].image!,
                      state.productsPaginated![index].barCode!,
                      state.productsPaginated![index].discount!,
                      state.productsPaginated![index].productUnitListModel![0]
                          .unitId!,
                      state.productsPaginated![index].productUnitListModel![0]
                          .unitName!,
                      state.productsPaginated![index].productUnitListModel![0]
                          .description!,
                      0,
                      state.productsPaginated![index].productUnitListModel![0]
                          .quantity!,
                      0,
                      state.productsPaginated![index].productUnitListModel![0]
                          .price!,
                    );
                  } else {
                    print('Loading');
                    return Center(child: SpinKitApp(width));
                  }
                },
                itemCount: state.categoryStatus == CategoryStatus.loading
                    ? state.productsPaginated!.length + 1
                    : state.productsPaginated!.length,
              ),
              SizedBox(
                height: height * 0.05,
              ),
            ],
          ),
        ),
      ),
      fallback: (context) => SpinKitApp(width),
    );
  }
}
