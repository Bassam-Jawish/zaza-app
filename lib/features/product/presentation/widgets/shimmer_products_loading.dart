import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/app_export.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';

class ShimmerProductsLoading extends StatelessWidget {
  const ShimmerProductsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBaseColor!,
      highlightColor: AppColor.shimmerHighlightColor,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerPlaceholder(
                height: 30.h,
                width: 300.w,
              ),
              SizedBox(
                height: height * 0.025,
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: width * 0.5,
                  mainAxisExtent: height * 0.4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ShimmerPlaceholder(
                    radius: 15,
                  );
                },
                itemCount: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
