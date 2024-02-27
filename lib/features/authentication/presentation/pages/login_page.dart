import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../widgets/login_body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      appBar: null,
      body: SafeArea(child: LoginBody()),
    );
  }
}
