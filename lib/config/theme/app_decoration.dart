import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/config/theme/styles.dart';

class AppDecoration {
  // Gradient decorations
  static Gradient get primaryGradient => const LinearGradient(colors: [
        AppColor.primaryLight,
        Colors.red,
      ]);

  static PinTheme get defaultPinTheme => PinTheme(
    width: 56.w,
    height: 56.h,
    textStyle: Styles.textStyle18.copyWith(color: Colors.black),
    decoration: BoxDecoration(
      border: Border.all(color: AppColor.gray500),
      borderRadius: BorderRadius.circular(20.r),
    ),
  );

  static PinTheme get focusedPinTheme => PinTheme(
    width: 56.w,
    height: 56.h,
    textStyle: Styles.textStyle18.copyWith(color: Colors.black),
    decoration: BoxDecoration(
      border: Border.all(color: AppColor.primaryLight),
      borderRadius: BorderRadius.circular(20.r),
    ),
  );

  static PinTheme get submittedPinTheme => PinTheme(
    width: 56.w,
    height: 56.h,
    textStyle: Styles.textStyle18.copyWith(color: Colors.black),
    decoration: BoxDecoration(
      border: Border.all(color: AppColor.primaryLight),
      borderRadius: BorderRadius.circular(20.r),
    ),
  );
}
