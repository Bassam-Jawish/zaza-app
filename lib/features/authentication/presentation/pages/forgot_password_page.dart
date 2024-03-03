import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../widgets/forgot_password_body.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();

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
        appBar: CustomAppBar('', width, height, context, false),
        body: ForgotPasswordBody(_emailController, _emailFocusNode, _formKey),
      ),
    );
  }
}
