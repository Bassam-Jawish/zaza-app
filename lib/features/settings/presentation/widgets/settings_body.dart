import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaza_app/features/favorite/presentation/pages/favorite_page.dart';
import 'package:zaza_app/features/settings/presentation/widgets/settings_container.dart';

import '../../../../core/app_export.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../base/presentation/widgets/push_bottom_bar.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import 'change_language_dialog.dart';
import 'logout_dialog.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.loadingLogout) {
          EasyLoading.show();
        }
        if (state.authStatus == AuthStatus.successLogout) {
          EasyLoading.dismiss();
          showToast(text: AppLocalizations.of(context)!.logout, state: ToastState.success);
        }
        if (state.authStatus == AuthStatus.errorLogout) {
          EasyLoading.dismiss();
          showToast(text: AppLocalizations.of(context)!.logout, state: ToastState.success);
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SettingsContainer(
                    Icons.favorite,
                    () {
                      pushNewScreenWithNavBar(
                          context, FavoritePage(), '/favorite');
                    },
                    AppLocalizations.of(context)!.my_Favorites,
                  ),
                  SettingsContainer(
                    Icons.language,
                    () {
                      changeLanguageDialog(context, width, height);
                    },
                    AppLocalizations.of(context)!.language_Settings,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SettingsContainer(
                    Icons.shopping_cart,
                    () {
                      pushNewScreenWithNavBar(context, OrdersPage(), '/orders');
                    },
                    AppLocalizations.of(context)!.orders_Details,
                  ),
                  SettingsContainer(
                    Icons.logout,
                    () {
                      awsDialogLogout(context, width, 0);
                    },
                    AppLocalizations.of(context)!.logout,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
