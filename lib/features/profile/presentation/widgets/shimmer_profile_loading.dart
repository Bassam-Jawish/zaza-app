import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/app_export.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';

class ShimmerProfileLoading extends StatelessWidget {
  const ShimmerProfileLoading({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: ShimmerPlaceholder(
                width: double.infinity,
                height: height * 0.2,
                radius: 50,
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerPlaceholder(
                        width: 140.w,
                        height: 30.h,
                      ),
                      ShimmerPlaceholder(
                        width: width * 0.35,
                        height: height * 0.055,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                  height: height * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerPlaceholder(
                        width: 140.w,
                        height: 30.h,
                      ),
                      ShimmerPlaceholder(
                        width: 140.w,
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                SizedBox(
                  height: height * 0.3,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      width: width * 0.04,
                    ),
                    itemBuilder: (context, index) {
                      return ShimmerPlaceholder(
                        width: width * 0.53,
                        radius: 50,
                      );
                    },
                    itemCount: 10,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
