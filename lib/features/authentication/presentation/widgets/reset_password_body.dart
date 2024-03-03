import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zaza_app/core/utils/functions/spinkit.dart';
import 'package:zaza_app/core/widgets/default_textformfield.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/app_export.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/custom_toast.dart';

class ResetPasswordBody extends StatelessWidget {
  ResetPasswordBody(
      this.email,
      this.code,
      this._passwordController,
      this._passwordFocusNode,
      this._passwordConfirmController,
      this._passwordConfirmFocusNode,
      this._formKey,
      {Key? key})
      : super(key: key);

  final String email;
  final String code;
  final TextEditingController _passwordController;
  final FocusNode _passwordFocusNode;

  final TextEditingController _passwordConfirmController;
  final FocusNode _passwordConfirmFocusNode;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.successResetPass) {
          GoRouter.of(context).pushReplacement('${AppRouter.kLoginPage}');
          showToast(
              text: '${AppLocalizations.of(context)!.password_has_updated}',
              state: ToastState.success);
        }
        if (state.authStatus == AuthStatus.errorResetPass) {
          showToast(text: state.error!.message, state: ToastState.error);
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(context),
                SizedBox(height: 40.h),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return def_TextFromField(
                      keyboardType: TextInputType.text,
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      hintText:
                          "${AppLocalizations.of(context)!.enter_your_password}",
                      hintStyle: Styles.textStyle16,
                      prefixIcon: Container(
                        margin: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 14.h),
                        child: CustomImageView(
                          imagePath: Assets.images.imgPassword.path,
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(const ChangePassword());
                        },
                        iconSize: 26,
                        icon: state.isPasswordVis!
                            ? const Icon(
                                Icons.visibility_outlined,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.visibility_off_outlined,
                                color: Colors.grey,
                              ),
                      ),
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_passwordConfirmFocusNode);
                      },
                      obscureText: !state.isPasswordVis!,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "${AppLocalizations.of(context)!.please_enter_your_Password}";
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 16.h),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return def_TextFromField(
                      keyboardType: TextInputType.text,
                      controller: _passwordConfirmController,
                      focusNode: _passwordConfirmFocusNode,
                      hintText:
                          "${AppLocalizations.of(context)!.confirm_password}",
                      hintStyle: Styles.textStyle16,
                      prefixIcon: Container(
                        margin: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 14.h),
                        child: CustomImageView(
                          imagePath: Assets.images.imgPassword.path,
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(const ChangePassword());
                        },
                        iconSize: 26,
                        icon: state.isPasswordVis!
                            ? const Icon(
                                Icons.visibility_outlined,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.visibility_off_outlined,
                                color: Colors.grey,
                              ),
                      ),
                      obscureText: !state.isPasswordVis!,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "${AppLocalizations.of(context)!.please_enter_your_Password}";
                        }
                        if (value != _passwordController.text) {
                          return "${AppLocalizations.of(context)!.password_does_not_match}";
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 24.h),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return state.isResetPasswordLoading!
                        ? Center(child: SpinKitApp(width))
                        : CustomButton(
                            text:
                                '${AppLocalizations.of(context)!.create_password}',
                            image: '',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(ResetPassword(
                                    email, code, _passwordController.text));
                              }
                            },
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("${AppLocalizations.of(context)!.create_password}",
          style: Styles.textStyle24),
      SizedBox(height: 12.h),
      Text(
        "${AppLocalizations.of(context)!.create_your_new}",
        style: Styles.textStyle16,
        maxLines: 2,
      )
    ]);
  }
}
