
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zaza_app/config/theme/colors.dart';

Widget SpinKitApp(width) {
  return SpinKitFadingCircle(
    color: AppColor.primaryLight,
    size: 30,
  );
}