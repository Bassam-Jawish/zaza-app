import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../widgets/reset_password_body.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage(this.email, this.code, {Key? key}) : super(key: key);

  final String email;
  final String code;

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final FocusNode _passwordConfirmFocusNode = FocusNode();

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
        body: ResetPasswordBody(
            email,
            code,
            _passwordController,
            _passwordFocusNode,
            _passwordConfirmController,
            _passwordConfirmFocusNode,
            _formKey),
      ),
    );
  }
}
