import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';

import '../../../../core/app_export.dart';

Widget NoSearchYet(height, context) {
  return Column(
    children: [
      Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColor.gray300,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Icon(
              Icons.search,
              color: AppColor.primaryLight,
              size: 40,
            ),
          ),
        ),
      ),
      SizedBox(
        height: height * 0.04,
      ),
      Text(
        '${AppLocalizations.of(context)!.use_the_keyboard}',
        style: TextStyle(
            color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
