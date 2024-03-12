import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/app_export.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';

class ShimmerOrderDetailsLoading extends StatelessWidget {
  const ShimmerOrderDetailsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerPlaceholder(
                height: height * 0.2,
                width: double.infinity,
              ),
              SizedBox(
                height: height * 0.04,
              ),
              ShimmerPlaceholder(
                height: 30.h,
                width: 150.w,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, mainIndex) {
                  return ShimmerPlaceholder(
                    height: height * 0.32,
                  );
                },
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: height * 0.02,
                ),
                itemCount: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
