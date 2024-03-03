import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NothingWidget extends StatelessWidget {
  const NothingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_outlined,
                color: AppColor.secondaryLight,
                size: 20,
              ),
              iconSize: 20,
            ),
            Text(
              '${AppLocalizations.of(context)!.nothing_Found}',
              style: TextStyle(
                  color: AppColor.secondaryLight,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
  }
}
