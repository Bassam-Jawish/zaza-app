import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaza_app/config/theme/colors.dart';

import '../../../../config/config.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../injection_container.dart';
import '../../../base/presentation/widgets/push_bottom_bar.dart';
import '../pages/categories_page.dart';

class SubCategoryCard extends StatelessWidget {
  SubCategoryCard(
      this.sub_id, this.categoryName, this.imagePath, this.itemsNumber,
      {super.key});

  final int sub_id;
  final String categoryName;
  final String imagePath;
  final int itemsNumber;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var theme = Theme.of(context).colorScheme;
    String path = '${imagePath}';
    return Container(
      height: height * 0.18,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0.1),
            color: Colors.redAccent.withOpacity(0.2),
            blurRadius: 6,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            categoryId = sub_id;
            pushNewScreenWithNavBar(context, CategoryPage(), '/categories');
          },
          borderRadius: BorderRadius.circular(30),
          splashColor: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  border: Border.all(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    topLeft: Radius.circular(30.r),
                  ),
                  child:

                  CustomImageView(
                    imagePath: path,
                    width: width*0.32,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.02,
              ),
              Container(
                width: width * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${itemsNumber.toString()} ${AppLocalizations.of(context)!.items}',
                      style: TextStyle(color: AppColor.secondaryLight, fontSize: 17.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      '${categoryName}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryLight,
                          fontSize: 17.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_outlined,
                size: 20.sp,
                color: AppColor.secondaryLight,
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}
