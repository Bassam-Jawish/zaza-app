import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/app_export.dart';

PreferredSizeWidget CustomProductAppBar(
    String title, width, height, context, bool isShowPop) {
  return AppBar(
    leading: isShowPop ? IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back,
        color: AppColor.secondaryLight,
        size: 20.sp,
      ),
      iconSize: 20.sp,
    ) : SizedBox(),
    leadingWidth: 90.w,
    centerTitle: true,
    backgroundColor: AppColor.backgroundColorLight,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    elevation: 1,
    title: Text(title),
    titleTextStyle: TextStyle(
        fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black),
  );
}
