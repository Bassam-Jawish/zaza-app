import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/core/widgets/custom_image_view.dart';
import 'package:zaza_app/features/product/presentation/widgets/unit_card.dart';

import '../../../../core/app_export.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../bloc/product/product_bloc.dart';

class ProductBody extends StatelessWidget {
  ProductBody(this.state, {super.key});
  ProductState state;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ConditionalBuilder(
      condition: state.isProductProfileLoaded!,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: theme.primary,
                    width: 0.5,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04, vertical: height * 0.025),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*likeButtonWidget(45.0),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        state.productProfile!.discount != 0
                            ? Container(
                                decoration: BoxDecoration(
                                    color: theme.primary,
                                    borderRadius: BorderRadius.circular(20)),
                                width: width * 0.2,
                                height: height * 0.04,
                                child: Center(
                                  child: Text(
                                    '${state.productProfile!.discount}%',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Center(
                      child: CustomImageView(
                        width: width * 0.6,
                        height: height * 0.2,
                        imagePath: '${baseUrl}*${state.productProfile!.image!}',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Text(
                      state.productProfile!.productName!,
                      style: TextStyle(
                          color: theme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 3),
                      color: Colors.redAccent.withOpacity(0.2),
                      blurRadius: 5,
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04, vertical: height * 0.025),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.product_Details}',
                      style: TextStyle(
                          fontSize: 23.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.secondary),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.tax}: ${state.productProfile!.taxName} (${state.productProfile!.taxPercent}%)',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.product_No}: #${state.productProfile!.barCode}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Text(
                '${AppLocalizations.of(context)!.determine}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => UnitCard(
                      index,
                      state.productProfile!.discount!,
                      state
                          .productProfile!.productUnitListModel![index].unitId!,
                      state.productProfile!.productUnitListModel![index]
                          .unitName!,
                      state.productProfile!.productUnitListModel![index]
                          .description!,
                      state.productProfile!.productUnitListModel![index].price,
                      state),
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                        height: height * 0.02,
                      ),
                  itemCount:
                      state.productProfile!.productUnitListModel!.length),
              SizedBox(
                height: height * 0.08,
              ),
            ],
          ),
        ),
      ),
      fallback: (context) => SpinKitApp(width),
    );
  }
}
