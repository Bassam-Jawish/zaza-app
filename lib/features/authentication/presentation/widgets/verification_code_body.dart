import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/core/utils/functions/spinkit.dart';
import 'package:zaza_app/core/widgets/custom_toast.dart';
import 'package:zaza_app/injection_container.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/custom_button.dart';

class VerificationCodeBody extends StatelessWidget {
  VerificationCodeBody(this.email, this._pinCode, this._formKey, this._pinCodeFocusNode,{super.key});

  final String email;

  final TextEditingController _pinCode;

  final FocusNode _pinCodeFocusNode;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.successValidateResetPass) {
          FocusManager.instance.primaryFocus?.unfocus();
          GoRouter.of(context).push(
              '${AppRouter.kLoginPage}/${AppRouter.kForgotPasswordPage}/${AppRouter.kVerificationForgotPage}/${email}/${AppRouter.kResetPasswordPage}/${email}/${_pinCode.text}');
        }
        if (state.authStatus == AuthStatus.errorValidateResetPass) {
          showToast(text: state.error!.message, state: ToastState.error);
        }
        if (state.authStatus == AuthStatus.loadingForgotPass) {
          EasyLoading.show();
        }
        if (state.authStatus == AuthStatus.successLogout) {
          EasyLoading.dismiss();
          showToast(text: AppLocalizations.of(context)!.verification_sent, state: ToastState.success);
        }
        if (state.authStatus == AuthStatus.errorForgotPass) {
          EasyLoading.dismiss();
          showToast(text: state.error!.message, state: ToastState.error);
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  _buildTitle(context, email),
                  SizedBox(height: 40.h),
                  // pin code
                  Pinput(
                    onCompleted: (val) {
                      _pinCodeFocusNode.unfocus();
                    },
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    length: 4,
                    validator: (value) {
                      return null;
                    },
                    focusNode: _pinCodeFocusNode,
                    showCursor: true,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    controller: _pinCode,
                    closeKeyboardWhenCompleted: true,
                    defaultPinTheme: AppDecoration.defaultPinTheme,
                    focusedPinTheme: AppDecoration.focusedPinTheme,
                    submittedPinTheme: AppDecoration.submittedPinTheme,
                  ),

                  SizedBox(height: 40.h),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return state.isValidateResetPasswordLoading!
                          ? Center(child: SpinKitApp(width))
                          : CustomButton(
                              text:
                                  '${AppLocalizations.of(context)!.send_code}',
                              image: '',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                      ValidateResetPassword(
                                          email, _pinCode.text));
                                }
                              },
                            );
                    },
                  ),
                  SizedBox(height: 25.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${AppLocalizations.of(context)!.receive_the} ",
                          style: Styles.textStyle12.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColor.gray500)),
                      SizedBox(width: 10.w,),
                      TextButton(
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(ForgotPassword(email, true));
                        },
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Text(
                          '${AppLocalizations.of(context)!.resend}',
                          style: Styles.textStyle12.copyWith(
                            color: theme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              )),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String email) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(left: 1.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${AppLocalizations.of(context)!.enter_ver}",
              style: Styles.textStyle24),
          SizedBox(height: 30.h),
          Container(
            width: 270.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${AppLocalizations.of(context)!.enter_code_that} ",
                  style: Styles.textStyle16.copyWith(color: AppColor.gray500),
                  maxLines: 2,
                ),
                Text(email,
                    style: Styles.textStyle16.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
