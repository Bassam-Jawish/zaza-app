import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/features/orders/presentation/pages/order_details_page.dart';

import '../../../../core/app_export.dart';
import '../../../../injection_container.dart';
import '../../../base/presentation/widgets/push_bottom_bar.dart';

class OrderCard extends StatelessWidget {
  OrderCard(
      this.index, this.order_id, this.total_price, this.totalPriceAfterTax,this.created_at, this.status,
      {super.key});

  int index;
  int order_id;
  dynamic total_price;
  dynamic totalPriceAfterTax;

  String created_at;
  String status;

  @override
  Widget build(BuildContext context) {
    DateTime inputDate = DateTime.parse(created_at);
    String outputDateString =
        DateFormat("yyyy/MM/dd : HH:m:s").format(inputDate);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var theme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Container(
          width: width * 0.53,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: theme.primary,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 0.1),
                color: Colors.redAccent.withOpacity(0.2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: height * 0.01,
              ),
              Text(
                '${AppLocalizations.of(context)!.invoice_price}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp),
              ),
              Text(
                '${total_price}\€',
                style: TextStyle(
                    color: theme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp),
              ),
              Text(
                '${AppLocalizations.of(context)!.invoice_with_tax}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp),
              ),
              Text(
                '${totalPriceAfterTax}\€',
                style: TextStyle(
                    color: theme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp),
              ),
              Container(
                height: height * 0.04,
                width: width * 0.26,
                decoration: BoxDecoration(
                  color: theme.primary,
                  borderRadius: BorderRadius.circular(12.0.r),
                ),
                child: ElevatedButton(
                  child: Text(
                    '${AppLocalizations.of(context)!.see_details}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp),
                  ),
                  onPressed: () {
                    orderId = order_id;
                    pushNewScreenWithoutNavBar(
                        context, OrderDetailsPage(), '/order-details');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Text(
                '${AppLocalizations.of(context)!.invoice_Date}',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp),
              ),
              Text(
                '${outputDateString}',
                style: TextStyle(
                    color: AppColor.shadeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                    letterSpacing: 1),
              ),
            ],
          ),
        ),
        Positioned(
          left: 10.0,
          top: 0.0,
          child: Container(
            height: height * 0.024,
            width: width * 0.17,
            decoration: BoxDecoration(
              color: status == 'pending'
                  ? Colors.yellow
                  : status == 'approved'
                      ? Colors.green
                      : Colors.red,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Text(
                status == 'pending'
                    ? '${AppLocalizations.of(context)!.pending}'
                    : status == 'approved'
                        ? '${AppLocalizations.of(context)!.approved}'
                        : '${AppLocalizations.of(context)!.rejected}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
