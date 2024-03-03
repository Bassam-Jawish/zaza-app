import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/colors.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/default_textformfield.dart';
import '../bloc/auth_bloc.dart';
import 'login_button.dart';

class InputBodyWidget extends StatelessWidget {
  InputBodyWidget(this._userNameController, this._userNameFocusNode, this._passwordController, this._passwordFocusNode, this._formKey, {super.key});

  TextEditingController _userNameController = TextEditingController();
  FocusNode _userNameFocusNode = FocusNode();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordFocusNode = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          height: height * 0.62,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0.r),
              topRight: Radius.circular(40.0.r),
            ),
          ),

          padding: EdgeInsets.only(
              left: width * 0.08,right: width * 0.08, top: height * 0.03,bottom: 0.035),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.welcome,
                  style: TextStyle(
                      color: theme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 35.sp),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(
                  AppLocalizations.of(context)!
                      .please_login_with_your_information,
                  style: TextStyle(
                      color: theme.secondary,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Text(
                  AppLocalizations.of(context)!.username,
                  style: TextStyle(
                    color: AppColor.shadeColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                  ),
                ),
                def_TextFromField(
                  cursorColor: theme.primary,
                  autValidateMode:
                  AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  controller: _userNameController,
                  focusNode: _userNameFocusNode,
                  maxLines: 1,
                  prefixIcon: Icon(
                    Icons.person,
                    color: theme.secondary,
                  ),
                  onFieldSubmitted: (value) {
                    FocusScope.of(context)
                        .requestFocus(_passwordFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!
                          .please_enter_your_Username;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Text(
                  AppLocalizations.of(context)!.password,
                  style: TextStyle(
                    color: AppColor.shadeColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                  ),
                ),
                def_TextFromField(
                  cursorColor: theme.primary,
                  focusNode: _passwordFocusNode,
                  keyboardType: TextInputType.visiblePassword,
                  maxLines: 1,
                  controller: _passwordController,
                  obscureText: !state.isPasswordVis!,
                  autValidateMode:
                  AutovalidateMode.onUserInteraction,
                  prefixIcon: Icon(
                    Icons.lock,
                    color: theme.secondary,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(const ChangePassword());
                    },
                    icon: state.isPasswordVis!
                        ? const Icon(
                      Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 26,
                    )
                        : const Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.grey,
                      size: 26,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!
                          .please_enter_your_Password;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).push(
                        '${AppRouter.kLoginPage}/${AppRouter.kForgotPasswordPage}');
                  },
                  style: ButtonStyle(
                    overlayColor:
                    MaterialStateColor.resolveWith(
                            (states) => AppColor.shadeColor),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!
                        .forgot_Password,
                    style: TextStyle(
                      color: theme.secondary,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                ConditionalBuilder(
                  condition: state.authStatus != AuthStatus.loading,
                  builder: (context) => LoginButton(
                      _userNameController.text,
                      _passwordController.text,
                      _formKey),
                  fallback: (context) => SpinKitApp(width),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
