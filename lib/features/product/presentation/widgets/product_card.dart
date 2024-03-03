import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/config.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/core/widgets/custom_image_view.dart';
import 'package:zaza_app/features/product/presentation/pages/product_page.dart';

import '../../../../injection_container.dart';
import '../../../base/presentation/widgets/push_bottom_bar.dart';
import '../../../favorite/presentation/widgets/like_button.dart';

class ProductCard extends StatelessWidget {
  ProductCard(
      this.index,
      this.product_id,
      this.productName,
      this.imagePath,
      this.barCode,
      this.discount,
      this.productUnitId,
      this.productUnitName,
      this.productUnitDesc,
      this.myQuantity,
      this.quantity,
      this.likeButtonType,
      this.price,
      this.state,
      {super.key});

  final int index;
  final int product_id;
  final String productName;
  final String imagePath;
  final String barCode;
  final int discount;
  final int productUnitId;
  final String productUnitName;
  final String productUnitDesc;
  final int myQuantity;
  final int quantity;
  final int price;
  final int likeButtonType;
  dynamic state;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String path = '${baseUrl}${imagePath}';
    var theme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        productId = product_id;
        pushNewScreenWithoutNavBar(context, ProductPage(), '/product-profile');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 0.1),
              color: Colors.redAccent.withOpacity(0.2),
              blurRadius: 6,
            )
          ],
        ),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.015, vertical: height * 0.005),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                discount != 0
                    ? Container(
                        decoration: BoxDecoration(
                            color: theme.primary,
                            borderRadius: BorderRadius.circular(20)),
                        width: width * 0.1,
                        height: height * 0.03,
                        child: Center(
                          child: Text(
                            '${discount}%',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                          ),
                        ),
                      )
                    : Container(),
                likeButtonWidget(
                    context, 30.0, product_id, likeButtonType, index, state)
              ],
            ),
            Center(
              child: CustomImageView(
                width: width * 0.3,
                height: height * 0.1,
                imagePath: path,
                fit: BoxFit.contain,
              ),
            ),
            barCode == ''
                ? Container()
                : Center(
                    child: Text(
                      '#${barCode}',
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
            SizedBox(
              height: height * 0.005,
            ),
            Text(
              productName,
              style: TextStyle(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: height * 0.003,
            ),
            Text(
              productUnitName,
              style: TextStyle(
                  color: theme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: height * 0.003,
            ),
            Text(
              productUnitDesc,
              style: TextStyle(
                  color: theme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: height * 0.003,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      discount != 0
                          ? Text(
                              "${price}\€",
                              style: TextStyle(
                                color: AppColor.shadeColor,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: AppColor.shadeColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          : Container(),
                      SizedBox(
                        height: height * 0.003,
                      ),
                      Text(
                        "${(price * (100 - discount)) / 100}\€",
                        style: TextStyle(
                          color: theme.secondary,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: width * 0.1,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      /*quantityDialog(
                        width,
                        height,
                        context,
                        quantity,
                        formKey,
                        product_id,
                        productUnitId,
                      );*/
                    },
                    child: Icon(
                      Icons.shopping_cart,
                      color: theme.primary,
                    ),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(AppColor.shadeColor),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(theme.background),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                /*SizedBox(
                width: width * 0.1,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Icon(Icons.add),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(primaryColor),
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}
