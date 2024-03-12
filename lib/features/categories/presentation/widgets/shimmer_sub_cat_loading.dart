import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/app_export.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';

class ShimmerSubCatLoading extends StatelessWidget {
  const ShimmerSubCatLoading({super.key});

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
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: height * 0.02,
                ),
                itemBuilder: (context, index) {
                  return ShimmerPlaceholder(
                    height: height * 0.18,
                    width: 300.w,
                    radius: 50,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
