import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

ThemeData theme() {
  return ThemeData(
      useMaterial3: true,
      //fontFamily: FontFamily.raleway,
      navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: AppColor.bottomNavigationBarLight
      ),
      appBarTheme: appBarTheme(),
      colorScheme: const ColorScheme(
        background: AppColor.backgroundColorLight,
        onBackground: AppColor.onBackgroundColorLight,
        brightness: Brightness.light,
        primary: AppColor.primaryLight,
        onPrimary: AppColor.onPrimaryLight,
        secondary: AppColor.secondaryLight,
        onSecondary: AppColor.onSecondaryLight,
        error: AppColor.errorLight,
        onError: AppColor.onErrorLight,
        surface: AppColor.surfaceLight,
        onSurface: AppColor.onSurfaceLight,
      ),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: AppColor.backgroundColorLight,
    foregroundColor: Colors.black,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20.sp,fontFamily: 'PublicSans',fontWeight: FontWeight.bold),
  );
}

