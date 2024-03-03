import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/core/utils/functions/spinkit.dart';

import '../../../../core/app_export.dart';
import '../../../../core/widgets/nothing_widget.dart';
import '../../../../injection_container.dart';
import 'order_card.dart';

class OrdersBody extends StatelessWidget {
  const OrdersBody({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider<OrderBloc>.value(
        value: sl()..add(GetOrders(limit, 0, sort, 'all')),
        child: BlocConsumer<OrderBloc, OrderState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return ConditionalBuilder(
              condition: state.isOrdersLoaded!,
              builder: (context) => ConditionalBuilder(
                condition: state.ordersList!.isNotEmpty,
                builder: (context) => SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03, vertical: height * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: theme.secondary,
                                    size: 20,
                                  ),
                                  iconSize: 20,
                                ),
                                Text(
                                  '${AppLocalizations.of(context)!.orders_sent}  (${state.ordersList!.length!})',
                                  style: TextStyle(
                                      color: theme.secondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.sp),
                                ),
                              ],
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: state.statusSearch,
                                items: statusList
                                    .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style:
                                              TextStyle(color: theme.primary),
                                        )))
                                    .toList(),
                                onChanged: (item) {
                                  print(item);
                                  context
                                      .read<OrderBloc>()
                                      .add(ChangeDropdownValue(item!));
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.025,
                        ),
                        GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: width * 0.5,
                              mainAxisExtent: height * 0.26,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return OrderCard(
                                  index,
                                  state.generalOrdersEntity!.ordersList![index]
                                      .orderId!,
                                  state.generalOrdersEntity!.ordersList![index]
                                      .totalPrice!,
                                  state.generalOrdersEntity!.ordersList![index]
                                      .createdAt!,
                                  state.generalOrdersEntity!.ordersList![index]
                                      .status!);
                            },
                            itemCount: state.ordersList!.length),
                      ],
                    ),
                  ),
                ),
                fallback: (context) => Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03, vertical: height * 0.03),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: state.statusSearch,
                              items: statusList
                                  .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: TextStyle(color: theme.primary),
                                      )))
                                  .toList(),
                              onChanged: (item) {
                                print(item);
                                context
                                    .read<OrderBloc>()
                                    .add(ChangeDropdownValue(item!));
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.32,
                      ),
                      NothingWidget(),
                    ],
                  ),
                ),
              ),
              fallback: (context) => SpinKitApp(width),
            );
          },
        ));
  }
}
