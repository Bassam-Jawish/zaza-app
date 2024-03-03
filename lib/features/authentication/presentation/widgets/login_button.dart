import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/auth_bloc.dart';

class LoginButton extends StatelessWidget {
  LoginButton(this.userName,this.password,this.form,{super.key});

  final String userName;
  final String password;

  final GlobalKey<FormState> form;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        height: height * 0.06,
        width: width * 0.55,
        decoration: BoxDecoration(
          color: theme.primary,
          borderRadius: BorderRadius.circular(20.0.r),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              color: Colors.redAccent.withOpacity(0.5),
              blurRadius: 1,
            )
          ],
        ),
        child: ElevatedButton(
          child: Text(
            AppLocalizations.of(context)!.login,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 20.sp),
          ),
          onPressed: () {
            if (form.currentState!.validate()) {
              context.read<AuthBloc>().add(Login(userName, password));

            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ),
    );
  }
}
