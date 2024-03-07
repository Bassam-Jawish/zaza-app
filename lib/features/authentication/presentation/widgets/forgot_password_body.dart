import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zaza_app/core/widgets/custom_toast.dart';
import 'package:zaza_app/features/authentication/presentation/widgets/email_section.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/app_export.dart';
import 'forgot_password_widgets.dart';

class ForgotPasswordBody extends StatelessWidget {
  ForgotPasswordBody(this._emailController, this._emailFocusNode, this._formKey,
      {Key? key})
      : super(key: key);

  final TextEditingController _emailController;

  final FocusNode _emailFocusNode;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.successForgotPass) {
          showToast(
              text: AppLocalizations.of(context)!.verification_sent,
              state: ToastState.success);
          EasyLoading.dismiss();
          if (!state.isResend!) {
            GoRouter.of(context).push(
                '${AppRouter.kLoginPage}/${AppRouter.kForgotPasswordPage}/${AppRouter.kVerificationForgotPage}/${_emailController.text}');
          }
        }
        if (state.authStatus == AuthStatus.errorForgotPass) {
          EasyLoading.dismiss();
          showToast(text: state.error!.message, state: ToastState.error);
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildTitlePass(context),
              SizedBox(height: 14.h),
              EmailSection(_emailController, _emailFocusNode, _formKey),
              /*Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                def_TextFromField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  prefixIcon: Container(
                    margin: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 14.h),
                    child: CustomImageView(
                      imagePath: Assets.images.imgEmail.path,
                      height: 24.h,
                      width: 24.w,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !EmailValidator.validate(value)) {
                      return "${AppLocalizations.of(context)!.please_enter_valid}";
                    }
                    return null;
                  },
                  onFieldSubmitted: (val) {},
                  hintText: "xyz@gmail.com",
                  hintStyle: Styles.textStyle16,
                ),
                SizedBox(height: 32.h),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return state.isForgotPasswordLoading!
                        ? Center(child: SpinKitApp(width))
                        : CustomButton(
                      text: AppLocalizations.of(context)!.send_code,
                      image: '',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthBloc>(context)
                              .add(ForgotPassword(_emailController.text));
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),*/
            ],
          ),
        ),
      ),
    );
  }
}
