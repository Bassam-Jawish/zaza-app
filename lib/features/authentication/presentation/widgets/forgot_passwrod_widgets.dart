
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/custom_button.dart';
/*
Widget buildTitlePass(BuildContext context) {
  final theme = Theme.of(context).colorScheme;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Forgot your password?",
          style: Styles.textStyle24,
        ),
        SizedBox(height: 8.h),
        Text("Enter your email, we will send you confirmation code",
            maxLines: 2,
            style: Styles.textStyle16.copyWith(color: AppColor.gray500)),
      ],
    ),
  );
}

Widget buildEmailSection(
    BuildContext context, TextEditingController controller,FocusNode focusNode, formKey) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w),
    child: Column(
      children: [
        CustomTextFormField(
          controller: controller,
          focusNode: focusNode,
          hintText: "xyz@gmail.com",
          hintStyle: Styles.textStyle16,
          textInputType: TextInputType.emailAddress,
          prefix: Container(
            margin: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 14.h),
            child: CustomImageView(
              imagePath: Assets.icons.imgEmail.path,
              height: 24.h,
              width: 24.w,
            ),
          ),
          prefixConstraints: BoxConstraints(maxHeight: 56.h),
          validator: (value) {
            if (value!.isEmpty || !EmailValidator.validate(value)) {
              return "Please enter valid email";
            }
            return null;
          },
          contentPadding: EdgeInsets.only(top: 8.h, right: 30.w, bottom: 8.h),
        ),
        SizedBox(height: 32.h),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return state.isLoading!
                ? Center(child: circularLoading())
                : CustomButton(
                    text: 'Send Email Verification',
                    image: '',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<AuthBloc>(context).add(ResetPassword(controller.text));
                      }
                    },
                  );
          },
        ),
      ],
    ),
  );
}*/
