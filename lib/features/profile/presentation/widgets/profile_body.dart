import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/core/utils/functions/spinkit.dart';
import 'package:zaza_app/core/widgets/custom_toast.dart';
import 'package:zaza_app/features/orders/presentation/widgets/order_card.dart';
import 'package:zaza_app/features/profile/presentation/widgets/add_phone_dialog.dart';
import 'package:zaza_app/features/profile/presentation/widgets/phone_number_card.dart';

import '../../../../core/app_export.dart';
import '../../../../injection_container.dart';
import '../../../base/presentation/widgets/push_bottom_bar.dart';
import '../../../orders/presentation/pages/orders_page.dart';

class ProfileBody extends StatelessWidget {
  ProfileBody({super.key});

  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider<ProfileBloc>(
      create: (context) => sl()..add(GetUserProfile(languageCode)),
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state.profileStatus == ProfileStatus.error) {
                showToast(text: state.error!.message, state: ToastState.error);
              }
              if (state.profileStatus == ProfileStatus.errorCreatePhone) {
                showToast(text: state.error!.message, state: ToastState.error);
              }
              if (state.profileStatus == ProfileStatus.errorDeletePhone) {
                showToast(text: state.error!.message, state: ToastState.error);
              }
              if (state.profileStatus == ProfileStatus.success) {
                context.read<OrderBloc>().add(GetProfileOrders(limit, 0, sort, 'all'));
              }
            },
          ),
          BlocListener<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state.orderStatus == OrderStatus.error) {
                showToast(text: state.error!.message, state: ToastState.error);
              }
            },
          ),
        ],
        child: Builder(builder: (context) {
          final state = context.watch<ProfileBloc>().state;
          final orderState = context.watch<OrderBloc>().state;
          return orderState.isProfileOrdersLoaded!
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                        child: Container(
                          width: double.infinity,
                          height: height * 0.2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red,
                                theme.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.03,
                              vertical: height * 0.02),
                          child: Column(
                            children: [
                              /*CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Image.asset(
                                  'assets/images/profile.png',
                                  width: width * 0.3,
                                  height: height * 0.15,
                                  fit: BoxFit.fill,
                                ),
                              ),*/
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.restaurant_Name}:',
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Text(
                                    state.userProfileEntity!.name!,
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.018,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.username}:',
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Text(
                                    state.userProfileEntity!.userName!,
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.015,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  Text(
                                    state.userProfileEntity!.email!,
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white54),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone_android,
                                      size: 20.sp,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      '${AppLocalizations.of(context)!.phone_Numbers}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20.sp),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: height * 0.055,
                                  width: width * 0.40,
                                  decoration: BoxDecoration(
                                    color: theme.primary,
                                    borderRadius: BorderRadius.circular(20.0.r),
                                  ),
                                  child: ElevatedButton(
                                    child: Center(
                                      child: Text(
                                        '${AppLocalizations.of(context)!.add_Phone_Number}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp),
                                      ),
                                    ),
                                    onPressed: () {
                                      addPhoneDialog(context, width, height,
                                          phoneNumberController);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0.r),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.01),
                              child: ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      PhoneNumberCard(
                                          index,
                                          state.userProfileEntity!
                                              .phonesList![index].number!,
                                          state.userProfileEntity!
                                              .phonesList![index].numberCode!,
                                          state.userProfileEntity!
                                              .phonesList![index].phoneId!,
                                          state.userProfileEntity!.userId!),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Divider(
                                            height: height * 0.02,
                                            color: Colors.grey,
                                            thickness: 0.5,
                                          ),
                                  itemCount: state
                                      .userProfileEntity!.phonesList!.length),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                            height: height * 0.05,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.payment,
                                      color: theme.secondary,
                                      size: 20.sp,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.my_Orders,
                                      style: TextStyle(
                                          color: theme.secondary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.sp),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    pushNewScreenWithoutNavBar(
                                        context, OrdersPage(), '/orders');
                                  },
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => AppColor.shadeColor),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.see_All,
                                    style: TextStyle(
                                      color: theme.secondary,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          SizedBox(
                            height: height * 0.23,
                            child: ListView.separated(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03),
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        SizedBox(
                                          width: width * 0.04,
                                        ),
                                itemBuilder: (context, index) {
                                  return OrderCard(
                                      index,
                                      orderState.generalOrdersEntity!
                                          .ordersList![index].orderId!,
                                      orderState.generalOrdersEntity!
                                          .ordersList![index].totalPrice!,
                                      orderState.generalOrdersEntity!
                                          .ordersList![index].createdAt!,
                                      orderState.generalOrdersEntity!
                                          .ordersList![index].status!);
                                },
                                itemCount: orderState
                                    .generalOrdersEntity!.ordersList!.length),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : SpinKitApp(width);
        }),
      ),
    );
  }
}
