import 'package:email_validator/email_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/app_export.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/default_textformfield.dart';

class EmailSection extends StatelessWidget {
  EmailSection(this._emailController, this._emailFocusNode, this._formKey, {Key? key}) : super(key: key);

  final TextEditingController _emailController;

  final FocusNode _emailFocusNode;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            def_TextFromField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
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
                    if (_formKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      BlocProvider.of<AuthBloc>(context)
                          .add(ForgotPassword(_emailController.text, false));
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
