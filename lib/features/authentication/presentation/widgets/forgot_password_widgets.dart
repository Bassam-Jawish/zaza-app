import 'package:email_validator/email_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/core/utils/functions/spinkit.dart';
import 'package:zaza_app/core/widgets/default_textformfield.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/app_export.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_image_view.dart';

Widget buildTitlePass(BuildContext context) {
  final theme = Theme.of(context).colorScheme;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 40.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${AppLocalizations.of(context)!.forgot_your}",
          style: Styles.textStyle24,
        ),
        SizedBox(height: 18.h),
        Text("${AppLocalizations.of(context)!.enter_your_email}",
            maxLines: 2,
            style: Styles.textStyle16.copyWith(color: AppColor.gray500)),
      ],
    ),
  );
}

Widget buildEmailSection(BuildContext context, TextEditingController controller,
    FocusNode focusNode,formKey, width) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w),
    child: Column(
      children: [
        def_TextFromField(
          keyboardType: TextInputType.emailAddress,
          controller: controller,
          focusNode: focusNode,
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
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<AuthBloc>(context)
                            .add(ForgotPassword(controller.text,false));
                      }
                    },
                  );
          },
        ),
      ],
    ),
  );
}
