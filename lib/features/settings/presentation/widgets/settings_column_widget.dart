import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';

import '../../../../config/theme/styles.dart';

class SettingsColumnWidget extends StatelessWidget {
  final String mainTitle;
  final List<SettingsItem> items;

  const SettingsColumnWidget({
    required this.mainTitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mainTitle,
          style: Styles.textStyle14.copyWith(
            color: AppColor.secondaryLight,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 0,
                blurRadius: 0.5, // Adjust blur radius as needed
                offset: Offset(0, 0.1),
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(vertical: 5.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: ListView.separated(
            itemBuilder: (context, index) => Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: AppColor.gray100,
                onTap: items[index].onTap,
                child: SizedBox(
                  height: 30.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            items[index].icon,
                            color: AppColor.gray500,
                            size: 18,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          SizedBox(
                            width: 230.w,
                            child: Text(
                              items[index].title,
                              style: Styles.textStyle16.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: AppColor.gray300,
              height: 20,
            ),
            itemCount: items.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

class SettingsItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
