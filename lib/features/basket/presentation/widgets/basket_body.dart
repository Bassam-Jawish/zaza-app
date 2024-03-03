import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/features/basket/presentation/widgets/basket_product_card.dart';
import 'package:zaza_app/features/product/presentation/widgets/send_order_dialog.dart';
import 'package:zaza_app/injection_container.dart';

import '../../../../core/app_export.dart';
import '../../../../core/utils/functions/spinkit.dart';

class BasketBody extends StatelessWidget {
  BasketBody({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  dynamic subTotal = 0.0;
  dynamic Total = 0.0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocConsumer<BasketBloc, BasketState>(
      listener: (context, state) {
        if (state.basketStatus == BasketStatus.getIds) {
          context
              .read<BasketBloc>()
              .add(GetBasketProducts(100000000, 0, languageCode));
        }
        if (state.basketStatus == BasketStatus.add) {
          context.read<BasketBloc>().add(GetIdQuantityForBasket());
        }
        if (state.basketStatus == BasketStatus.editBasket) {
          context.read<BasketBloc>().add(GetIdQuantityForBasket());
        }
        if (state.basketStatus == BasketStatus.remove) {
          context.read<BasketBloc>().add(GetIdQuantityForBasket());
        }
        if (state.basketStatus == BasketStatus.deleteAll) {
          context.read<BasketBloc>().add(GetIdQuantityForBasket());
        }
        if (state.basketStatus == BasketStatus.successSendOrder) {
          context.read<BasketBloc>().add(DeleteBasket());
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state.productEntity != null,
          builder: (context) => Container(
            height: height,
            width: width,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03, vertical: height * 0.03),
                        child: Form(
                          key: formKey,
                          child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                ///////////////
                                dynamic price = state.basketProductsList![index]
                                    .productUnitListModel![0].price!;

                                int discount =
                                    state.basketProductsList![index].discount!;

                                int myQuantity =
                                    state.productUnitHelper![index].quantity;

                                dynamic pricePerProduct = price * myQuantity;
                                String pricePerProductString =
                                    pricePerProduct.toStringAsFixed(1);

                                dynamic pricePerProductDiscount =
                                    ((price * (100 - discount)) / 100) *
                                        myQuantity;
                                String pricePerProductDiscountString =
                                    pricePerProductDiscount.toStringAsFixed(1);

                                return BasketProductCard(
                                    index: index,
                                    state: state,
                                    productIdBasket: state
                                        .basketProductsList![index].productId!,
                                    productName: state
                                        .basketProductsList![index]
                                        .productName!,
                                    image:
                                        state.basketProductsList![index].image!,
                                    discount: discount,
                                    unitId: state.basketProductsList![index]
                                        .productUnitListModel![0].unitId!,
                                    productUnitId: state
                                        .basketProductsList![index]
                                        .productUnitListModel![0]
                                        .productUnitId!,
                                    unitName: state.basketProductsList![index]
                                        .productUnitListModel![0].unitName!,
                                    unitDesc: state.basketProductsList![index]
                                        .productUnitListModel![0].description!,
                                    quantity: state.basketProductsList![index]
                                        .productUnitListModel![0].quantity!,
                                    price: price,
                                    pricePerProductString:
                                        pricePerProductString,
                                    pricePerProductDiscountString:
                                        pricePerProductDiscountString);
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) => SizedBox(
                                        height: height * 0.02,
                                      ),
                              itemCount: state.basketProductsList!.length),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.3,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  left: 0.0,
                  child: Container(
                    height: height * 0.33,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      border: Border.all(width: 0.5, color: Colors.black),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.16, vertical: height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${state.basketProductsList!.length} ${AppLocalizations.of(context)!.items_in_basket}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: Colors.black),
                        ),
                        SizedBox(height: height * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.total_Price}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${state.subTotal.toStringAsFixed(1)}\€',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Divider(
                          color: AppColor.shadeColor,
                          height: height * 0.04,
                          thickness: 0.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.final_Total}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${state.total.toStringAsFixed(1)}\€',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(height: height * 0.04),
                        !state.isLoading!
                            ? Container(
                                height: height * 0.04,
                                width: width * 0.45,
                                decoration: BoxDecoration(
                                  color: AppColor.primaryLight,
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: ElevatedButton(
                                  child: Text(
                                    '${AppLocalizations.of(context)!.order_Now}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp),
                                  ),
                                  onPressed: () {
                                    if (formKey.currentState!.validate() &&
                                        state.basketProductsList!.isNotEmpty) {
                                      awsDialogSendOrder(context, width, 0);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                              )
                            : SpinKitApp(width),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          fallback: (context) => SpinKitApp(width),
        );
      },
    );
  }
}
