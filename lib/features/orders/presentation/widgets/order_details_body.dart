import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/core/widgets/custom_image_view.dart';
import 'package:zaza_app/core/widgets/custom_toast.dart';

import '../../../../core/app_export.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../injection_container.dart';
import '../bloc/order_bloc.dart';

class OrderDetailsBody extends StatelessWidget {
  const OrderDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider<OrderBloc>.value(
      value: sl()..add(GetOrderDetails(orderId)),
      child: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state.orderStatus == OrderStatus.errorOrder) {
            showToast(text: state.error!.message, state: ToastState.error);
          }
        },
        builder: (context, state) {
          return ConditionalBuilder(
            condition: state.isOrderDetailsLoaded!,
            builder: (context) => SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04, vertical: height * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: height * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: theme.primary,
                          width: 1,
                        ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  /*Text('Status: ',style: TextStyle(color: Colors.black,fontSize: 16.sp,fontWeight: FontWeight.w600),),
                                      Text('${cubit.orderDetailsModel!.status}',style: TextStyle(color: Colors.black,fontSize: 16.sp,fontWeight: FontWeight.w600),),*/
                                  Text(
                                    '${AppLocalizations.of(context)!.status}: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  state.orderDetailsEntity!.status == 'approved'
                                      ? Text(
                                          '${AppLocalizations.of(context)!.approved}',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w600),
                                        )
                                      : state.orderDetailsEntity!.status ==
                                              'pending'
                                          ? Text(
                                              '${AppLocalizations.of(context)!.pending}',
                                              style: TextStyle(
                                                  color: Colors.yellow,
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          : Text(
                                              '${AppLocalizations.of(context)!.rejected}',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                ],
                              ),
                              Row(
                                children: [
                                  /*Text('Invoice Value: ',style: TextStyle(color: Colors.black,fontSize: 12.sp,fontWeight: FontWeight.w400),),
                                      Text('${cubit.orderDetailsModel!.totalPrice}\€',style: TextStyle(color: Colors.black,fontSize: 12.sp,fontWeight: FontWeight.w400),),*/
                                  Text(
                                    '${AppLocalizations.of(context)!.invoice_Value}: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: width * 0.3,
                                    child: Text(
                                      '${NumberFormat('#,###').format(state.orderDetailsEntity!.totalPrice)}\€',
                                      style: TextStyle(
                                          color: theme.primary,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  /*Text('Invoice Value: ',style: TextStyle(color: Colors.black,fontSize: 12.sp,fontWeight: FontWeight.w400),),
                                      Text('${cubit.orderDetailsModel!.totalPrice}\€',style: TextStyle(color: Colors.black,fontSize: 12.sp,fontWeight: FontWeight.w400),),*/
                                  Text(
                                    '${AppLocalizations.of(context)!.invoice_with_tax}: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: width * 0.3,
                                    child: Text(
                                      '${NumberFormat('#,###').format(state.orderDetailsEntity!.totalPriceAfterTax ?? 0)}\€',
                                      style: TextStyle(
                                          color: theme.primary,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${DateFormat("yyyy/MM/dd : HH:m:s").format(DateTime.parse(state.orderDetailsEntity!.createdAt!))}',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300),
                              ),
                              //  Text('${cubit.orderDetailsModel!.createdAt}',style: TextStyle(color: Colors.grey,fontSize: 12.sp,fontWeight: FontWeight.w400),),
                            ],
                          ),
                          Icon(
                            Icons.shopping_cart,
                            color: theme.primary,
                            size: 45,
                          ),
                          //Image.asset(''),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.add_shopping_cart,
                              color: theme.secondary,
                              size: 20,
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.ordered_products}',
                              style: TextStyle(
                                  color: theme.secondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, mainIndex) {
                        var path =
                            '${state.orderDetailsEntity!.productsOrderDetailsList![mainIndex].image}';
                        return Container(
                          height: height * 0.32,
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
                              horizontal: width * 0.03,
                              vertical: height * 0.01),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomImageView(
                                    width: width * 0.3,
                                    height: height * 0.12,
                                    imagePath: '${path}',
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  SizedBox(
                                    width: width * 0.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${state.orderDetailsEntity!.productsOrderDetailsList![mainIndex].productName}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.sp,
                                              color: theme.primary),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        Text(
                                          '#${state.orderDetailsEntity!.productsOrderDetailsList![mainIndex].barCode}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                              color: Colors.yellow),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              SizedBox(
                                height: height * 0.15,
                                child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Container(
                                    width: width * 0.45,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFFEF9F9),
                                        borderRadius: BorderRadius.circular(15),
                                        border:
                                            Border.all(color: theme.primary)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.03,
                                        vertical: height * 0.01),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          '${state.orderDetailsEntity!.productsOrderDetailsList![mainIndex].productUnitsOrderDetailsList![index].unitOrderModel!.unitName}',
                                          style: TextStyle(
                                              color: theme.primary,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          '${state.orderDetailsEntity!.productsOrderDetailsList![mainIndex].productUnitsOrderDetailsList![index].desc}',
                                          style: TextStyle(
                                              color: AppColor.shadeColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          'Amount: ${state.orderDetailsEntity!.productsOrderDetailsList![mainIndex].productUnitsOrderDetailsList![index].unitDetailsOrderModel!.amount}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          '${state.orderDetailsEntity!.productsOrderDetailsList![mainIndex].productUnitsOrderDetailsList![index].unitDetailsOrderModel!.totalPrice}€',
                                          style: TextStyle(
                                              color: theme.primary,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          SizedBox(
                                    width: width * 0.1,
                                  ),
                                  itemCount: state
                                      .orderDetailsEntity!
                                      .productsOrderDetailsList![mainIndex]
                                      .productUnitsOrderDetailsList!
                                      .length,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        height: height * 0.02,
                      ),
                      itemCount: state
                          .orderDetailsEntity!.productsOrderDetailsList!.length,
                    ),
                  ],
                ),
              ),
            ),
            fallback: (context) => SpinKitApp(width),
          );
        },
      ),
    );
  }
}
