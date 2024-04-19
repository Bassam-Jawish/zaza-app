import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/core/widgets/custom_image_view.dart';

import '../../../../injection_container.dart';
import '../../../base/presentation/widgets/push_bottom_bar.dart';
import '../../../basket/presentation/widgets/quantity_dialog.dart';
import '../../../product/presentation/pages/product_page.dart';

class BuildDiscountProductCard extends StatelessWidget {
  BuildDiscountProductCard(
      this.product_id,
      this.productName,
      this.imagePath,
      this.barCode,
      this.discount,
      this.productUnitId,
      this.productUnitDesc,
      this.myQuantity,
      this.quantity,
      this.productUnitName,
      this.price,
      {super.key});

  int product_id;
  String productName;
  String imagePath;
  String? barCode;
  int discount;
  int productUnitId;
  String productUnitName;
  String productUnitDesc;
  int myQuantity;
  int quantity;
  int price;


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String path = '${imagePath}';
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return GestureDetector(
      onTap: () {
        productId = product_id;
        pushNewScreenWithoutNavBar(context, ProductPage(), '/product-profile');
      },
      child: Container(
        width: width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          //gradient: AppDecoration.primaryGradient,
          color: AppColor.primaryLight,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: width * 0.43,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(
                    productUnitName,
                    style: TextStyle(
                        color: AppColor.shadeColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                      width: width * 0.36,
                      child: Text(
                        productUnitDesc,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 0.26,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${price}\€",
                              style: TextStyle(
                                color: AppColor.shadeColor,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: AppColor.shadeColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              "${price * (100 - discount) / 100}\€",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.1,
                            child: ElevatedButton(
                              onPressed: () {
                                quantityDialog(
                                    width,
                                    height,
                                    context,
                                    quantity,
                                    formKey,
                                    product_id,
                                    productUnitId);
                              },
                              child: Icon(
                                Icons.shopping_cart,
                                color: theme.primary,
                              ),
                              style: ButtonStyle(
                                overlayColor:
                                MaterialStateProperty.all<Color>(AppColor.shadeColor),
                                padding:
                                MaterialStateProperty.all(EdgeInsets.zero),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    theme.background),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                          /*SizedBox(
                      width: width * 0.1,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Icon(Icons.add),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(theme.primary),
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
                ],
              ),
            ),
            Stack(
              alignment: Alignment.topRight,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: width * 0.25,
                        height: height * 0.17,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                            color: Colors.white),

                        child: CustomImageView(
                          fit: BoxFit.contain,
                          imagePath: path,
                        ),
                      ),
                    ),
                    SizedBox(height: height*0.005,),
                    barCode == ''? Container() : SizedBox(width:width*0.28,child: Center(child: Text('#${barCode}',style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis,maxLines: 1,),)),
                  ],
                ),
                Container(
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
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
