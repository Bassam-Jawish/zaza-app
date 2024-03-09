import 'package:flutter/material.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/core/widgets/custom_appbar.dart';
import 'package:zaza_app/features/orders/presentation/widgets/order_details_body.dart';
import 'package:zaza_app/features/product/presentation/widgets/custom_product_appbar.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.background,
      //appBar: CustomAppBar(AppLocalizations.of(context)!.order_Details, width, height, context, false,false),
      appBar:  CustomProductAppBar(AppLocalizations.of(context)!.order_Details, width, height, context,true),
      body: OrderDetailsBody(),
    );
  }
}
