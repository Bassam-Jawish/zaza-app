import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/core/widgets/custom_image_view.dart';
import 'package:zaza_app/features/basket/presentation/widgets/edit_quantity_dialog.dart';
import 'package:zaza_app/features/product/presentation/pages/product_page.dart';
import 'package:zaza_app/features/product/presentation/widgets/delete_dialogs.dart';

import '../../../../core/app_export.dart';
import '../../../../injection_container.dart';
import '../../../base/presentation/widgets/push_bottom_bar.dart';

class BasketProductCard extends StatelessWidget {
  BasketProductCard({
    Key? key,
    required this.index,
    required this.state,
    required this.productIdBasket,
    required this.productName,
    required this.image,
    required this.discount,
    required this.unitId,
    required this.productUnitId,
    required this.unitName,
    required this.unitDesc,
    required this.quantity,
    required this.price,
    required this.pricePerProductString,
    required this.pricePerProductDiscountString,
  }) : super(key: key);

  final int index;
  final BasketState state;
  final int productIdBasket;
  final String productName;
  final String image;
  final int discount;
  final int unitId;
  final int productUnitId;
  final String unitName;
  final String unitDesc;
  final int quantity;
  final int price;
  final String pricePerProductString;
  final String pricePerProductDiscountString;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String path = '${image}';
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 3),
                color: Colors.redAccent.withOpacity(0.2),
                blurRadius: 5,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.01),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      productId = productIdBasket;
                      pushNewScreenWithoutNavBar(
                          context, ProductPage(), '/product-profile');
                    },
                    child: Container(
                      width: width * 0.28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.01, vertical: height * 0.01),
                      child: Center(
                        child: CustomImageView(
                          height: height * 0.15,
                          imagePath: path,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Container(
                    width: width * 0.35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${productName}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          '${unitName}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.sp,
                              color: theme.primary),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          '${unitDesc}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                              color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        discount != 0
                            ? Text(
                                '${price.toString()}\€',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19.sp,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : Container(),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Text(
                          '${(price * (100 - discount)) / 100}\€',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19.sp,
                              color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width * 0.24,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        discount != 0
                            ? Text(
                                '${pricePerProductString}\€',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.sp,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : Container(),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Text(
                          '${pricePerProductDiscountString}\€',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp,
                              color: theme.primary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.1,
                              child: ElevatedButton(
                                onPressed: () {
                                  awsDialogDeleteForOne(
                                      context, width, 0, index);
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: theme.background,
                                ),
                                style: ButtonStyle(
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColor.shadeColor),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColor.primaryLight),
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
                              width: width * 0.04,
                            ),
                            SizedBox(
                              width: width * 0.1,
                              child: ElevatedButton(
                                onPressed: () {
                                  quantityEditDialog(
                                      width,
                                      height,
                                      index,
                                      context,
                                      quantity,
                                      formKey,
                                      productIdBasket,
                                      productUnitId);
                                },
                                child: Icon(
                                  Icons.shopping_cart,
                                  color: theme.primary,
                                ),
                                style: ButtonStyle(
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColor.shadeColor),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          right: 0.0,
          child: Container(
            decoration: BoxDecoration(
                color: theme.primary, borderRadius: BorderRadius.circular(15)),
            width: width * 0.22,
            height: height * 0.03,
            child: Center(
              child: Text(
                '${state.productUnitHelper![index].quantity}/${quantity}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0.0,
          child: discount != 0
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
        ),
      ],
    );
  }
}
