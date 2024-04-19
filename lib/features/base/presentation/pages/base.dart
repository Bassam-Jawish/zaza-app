import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaza_app/core/widgets/custom_toast.dart';
import 'package:zaza_app/injection_container.dart';

import '../../../../core/app_export.dart';
import '../widgets/bottom_navigation_bar.dart';

class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  //final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BasketBloc, BasketState>(
      listener: (context, state) {
        if (state.basketStatus == BasketStatus.add) {
          //showToast(text: AppLocalizations.of(context)!.added_To_Basket_Successfully, state: ToastState.success);
          context.read<BasketBloc>().add(GetIdQuantityForBasket());
        }
        if (state.basketStatus == BasketStatus.errorAdd) {
          showToast(text: state.error!.message, state: ToastState.error);
          context.read<BasketBloc>().add(GetIdQuantityForBasket());
        }
        if (state.basketStatus == BasketStatus.getIds) {
          context
              .read<BasketBloc>()
              .add(GetBasketProducts(100000000, 0, languageCode));
        }
      },
      child: Scaffold(
        body: PersistentBottomNavigationBar(),
      ),
    );
  }
}
