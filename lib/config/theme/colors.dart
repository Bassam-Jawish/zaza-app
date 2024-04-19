import 'package:flutter/material.dart';

abstract class AppColor {
  const AppColor();

  static const Color dialogSuccess = Color(0xff01E47A);
  static const Color dialogFailed = Color(0xffFE5151);
  static const Color transparent = Colors.transparent;

  /// light
  static const Color backgroundColorLight = Color(0xFFF5F3F6);
  static const Color onBackgroundColorLight = Color(0xFF121212);
  static const Color bottomNavigationBarLight = Color(0xFF9A0002);
  static const Color primaryLight = Color(0xFF9A0002);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color secondaryLight = Color(0xFF686868);
  static const Color shadeColor = Color(0xFFBCBCBC);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color borderLightOnFocus = Color(0xFFFFFFFF);
  static const Color errorLight = Colors.redAccent;
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFFEEE6);
  static const Color onSurfaceLight = Color(0xFF121212);
  static const Color successColor = Color(0xFF24B364);

  // Gray
  static const Color gray100 = Color(0XFFF2F4F6);
  static const Color gray300 = Color(0XFFE0E2E4);
  static const Color gray500 = Color(0XFF90979E);
  static const Color gray600 = Color(0XFF6D747C);
  static const Color gray700 = Color(0X147C7C7C);

  // Shimmer Color

  static Color shimmerBaseColor = Colors.grey[300]!;
  static Color shimmerHighlightColor = Colors.grey[100]!;

}