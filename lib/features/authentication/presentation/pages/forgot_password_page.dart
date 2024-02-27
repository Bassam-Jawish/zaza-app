import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_appbar.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context, '', true),
      //body: ForgotPasswordBody(),
    );
  }
}
