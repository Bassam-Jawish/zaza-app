import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/features/favorite/presentation/pages/favorite_page.dart';
import 'package:zaza_app/features/settings/presentation/widgets/privacy_dialog.dart';
import 'package:zaza_app/features/settings/presentation/widgets/settings_column_widget.dart';
import 'package:zaza_app/features/settings/presentation/widgets/settings_container.dart';
import 'package:zaza_app/injection_container.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/app_export.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../base/presentation/widgets/push_bottom_bar.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
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
          showToast(
              text: AppLocalizations.of(context)!.logout,
              state: ToastState.success);
        }
        if (state.authStatus == AuthStatus.errorLogout) {
          EasyLoading.dismiss();
          showToast(text: state.error!.message, state: ToastState.error);
        }
        if (state.authStatus == AuthStatus.loadingDeleteAccount) {
          EasyLoading.show();
        }
        if (state.authStatus == AuthStatus.successDeleteAccount) {
          EasyLoading.dismiss();
          showToast(
              text: AppLocalizations.of(context)!.account_del,
              state: ToastState.success);
        }
        if (state.authStatus == AuthStatus.errorDeleteAccount) {
          EasyLoading.dismiss();
          showToast(text: state.error!.message, state: ToastState.error);
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.06, vertical: height * 0.01),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Zaza Großhandel',
                style: Styles.textStyle30.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SettingsColumnWidget(
                mainTitle: '${AppLocalizations.of(context)!.account}',
                items: [
                  SettingsItem(
                    icon: Icons.person,
                    title: '${AppLocalizations.of(context)!.my_profile}',
                    onTap: () {
                      pushNewScreenWithoutNavBar(
                          context, ProfilePage(), '/profile');
                    },
                  ),
                  SettingsItem(
                    icon: Icons.favorite,
                    title: '${AppLocalizations.of(context)!.my_Favorites}',
                    onTap: () {
                      pushNewScreenWithNavBar(
                          context, FavoritePage(), '/favorite');
                    },
                  ),
                  SettingsItem(
                    icon: Icons.shopping_cart,
                    title: '${AppLocalizations.of(context)!.my_Orders}',
                    onTap: () {
                      pushNewScreenWithNavBar(context, OrdersPage(), '/orders');
                    },
                  ),
                  SettingsItem(
                    icon: Icons.language,
                    title: '${AppLocalizations.of(context)!.language_Settings}',
                    onTap: () {
                      changeLanguageDialog(context, width, height);
                    },
                  ),
                ],
              ),
              SettingsColumnWidget(
                mainTitle: '${AppLocalizations.of(context)!.policy_and}',
                items: [
                  SettingsItem(
                    icon: Icons.privacy_tip,
                    title: '${AppLocalizations.of(context)!.privacy_policy}',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return PolicyDialog(
                            mdFileName: 'privacy_policy.md',
                          );
                        },
                      );
                    },
                  ),
                  SettingsItem(
                    icon: Icons.note,
                    title: '${AppLocalizations.of(context)!.terms}',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return PolicyDialog(
                            mdFileName: 'terms_and_conditions.md',
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              SettingsColumnWidget(
                mainTitle: '${AppLocalizations.of(context)!.account_man}',
                items: [
                  SettingsItem(
                    icon: Icons.delete_forever,
                    title: '${AppLocalizations.of(context)!.delete_account}',
                    onTap: () {
                      awsDialogLogout(context, width, 1);
                    },
                  ),
                  SettingsItem(
                    icon: Icons.logout,
                    title: '${AppLocalizations.of(context)!.logout}',
                    onTap: () {
                      awsDialogLogout(context, width, 0);
                    },
                  ),
                ],
              ),
              Center(
                  child: Text('Version ${version} (${buildNumber})',
                      style: Styles.textStyle14.copyWith(color: Colors.grey))),
            ],
          ),
        ),
      ),
    );
  }
}
