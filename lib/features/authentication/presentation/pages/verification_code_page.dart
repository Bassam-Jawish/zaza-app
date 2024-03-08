import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/app_export.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../widgets/login_body.dart';
import '../widgets/verification_code_body.dart';

class VerificationCodePage extends StatelessWidget {
  VerificationCodePage(this.email,{Key? key}) : super(key: key);

  final String email;

  final TextEditingController _pinCode = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: theme.background,
        appBar: CustomAppBar('', width, height, context, false,false),
        body: VerificationCodeBody(email, _pinCode, _formKey),
      ),
    );
  }
}
