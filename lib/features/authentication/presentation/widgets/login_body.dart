import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zaza_app/core/utils/gen/assets.gen.dart';
import 'package:zaza_app/core/widgets/custom_image_view.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/app_export.dart';
import '../../../../core/utils/cache_helper.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../injection_container.dart';
import '../../../settings/presentation/widgets/change_language_dialog.dart';
import '../bloc/auth_bloc.dart';
import 'input_body_widget.dart';

class LoginBody extends StatelessWidget {
  LoginBody({Key? key}) : super(key: key);

  final TextEditingController _userNameController = TextEditingController();
  final FocusNode _userNameFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {

        if (state.authStatus == AuthStatus.error) {
          /*showToast(
              text: AppLocalizations.of(context)!.invalid_userName_or_password,
              state: ToastState.error);*/
          showToast(text: state.error!.message, state: ToastState.error);
        }
        if (state.authStatus == AuthStatus.success) {

          token = state.accessToken;
          user_id = state.userEntity!.userId;
          user_name = state.userEntity!.userName;
          refresh_token = state.refreshToken;

          await SecureStorage.writeSecureData(key: 'user_id', value: user_id);
          await SecureStorage.writeSecureData(
              key: 'user_name', value: user_name);
          await SecureStorage.writeSecureData(
              key: 'refresh_token', value: refresh_token);
          await SecureStorage.writeSecureData(key: 'token', value: token);
          showToast(text: 'Login Successfully', state: state);
          GoRouter.of(context).pushReplacement(AppRouter.kBasePage);
        }

        if (state.authStatus == AuthStatus.loading) {
          FocusManager.instance.primaryFocus?.unfocus();
        }

      },
      child: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomImageView(
                    imagePath: Assets.images.logos.logoWhite512.path,
                    height: height * 0.35,
                    width: width * 0.7,
                    fit: BoxFit.fill),
                InputBodyWidget(_userNameController, _userNameFocusNode,
                    _passwordController, _passwordFocusNode, _formKey),
              ],
            ),
            IconButton(
              onPressed: () {
                changeLanguageDialog(context, width, height);
              },
              icon: Icon(
                Icons.language,
                color: Colors.white,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
