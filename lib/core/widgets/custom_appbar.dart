import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/colors.dart';
import '../../features/base/presentation/widgets/push_bottom_bar.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../utils/gen/assets.gen.dart';

PreferredSizeWidget CustomAppBar(String title, width, height, context, bool show) {
  return AppBar(
    centerTitle: true,
    backgroundColor: AppColor.backgroundColorLight,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    elevation: 1,
    title: Text(title),
    titleTextStyle: TextStyle(
        fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black),
    actions: [
      show ? GestureDetector(
          onTap: () {
            pushNewScreenWithoutNavBar(context, ProfilePage(), '/profile');
          },
          child: Image.asset(
            Assets.images.profile.path,
            height: height * 0.1,
            width: width * 0.15,
            fit: BoxFit.fill,
          )) : SizedBox(),
    ],
  );
}
