import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';

class AppDecoration {
  // Gradient decorations
  static Gradient get primaryGradient => const LinearGradient(colors: [
        AppColor.primaryLight,
        Colors.red,
      ]);
}
