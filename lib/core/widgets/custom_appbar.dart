import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/styles.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/features/product/presentation/widgets/delete_dialogs.dart';

import '../../config/theme/colors.dart';
import '../../features/base/presentation/widgets/push_bottom_bar.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../injection_container.dart';
import '../utils/gen/assets.gen.dart';

PreferredSizeWidget CustomAppBar(
    String title, width, height, context, bool show, bool showClearBasket) {
  return AppBar(
    leading: showClearBasket
        ? TextButton(
            onPressed: () {
              awsDialogDeleteForAll(context, width, 0);
            },
            child: Text(
              'Clear All',
              style: Styles.textStyle14,
            ),
          )
        : SizedBox(),
    leadingWidth: 100.w,
    centerTitle: true,
    backgroundColor: AppColor.backgroundColorLight,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    elevation: 1,
    title: Text(title),
    titleTextStyle: TextStyle(
        fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black),
    actions: [
      show
          ? GestureDetector(
              onTap: () {
                pushNewScreenWithoutNavBar(context, ProfilePage(), '/profile');
              },
              child: Image.asset(
                Assets.images.profile.path,
                height: height * 0.1,
                width: width * 0.15,
                fit: BoxFit.fill,
              ))
          : SizedBox(),
    ],
  );
}
