import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/app_export.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';

class ShimmerHomeLoading extends StatelessWidget {
  const ShimmerHomeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[100]!,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.03, vertical: height * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerPlaceholder(
                  height: 30.h,
                  width: 140.w,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerPlaceholder(
                      height: 30.h,
                      width: 140.w,
                    ),
                    ShimmerPlaceholder(
                      height: 30.h,
                      width: 140.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  height: height * 0.25,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: 2,
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    itemBuilder: (context, index) => ShimmerPlaceholder(
                      width: width * 0.8,
                      radius: 35,
                    ),
                    separatorBuilder: (context, index) => SizedBox(
                      width: width * 0.04,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerPlaceholder(
                      height: 30.h,
                      width: 140.w,
                    ),
                    ShimmerPlaceholder(
                      height: 30.h,
                      width: 140.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: width * 0.5,
                    mainAxisExtent: height * 0.36,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ShimmerPlaceholder(radius: 15,);
                  },
                  itemCount: 2,
                ),
              ],
            ),
          ),
        ));
  }
}
