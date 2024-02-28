import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_appbar.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar('Forgot Password', width, height, context),
      //body: ForgotPasswordBody(),
    );
  }
}
