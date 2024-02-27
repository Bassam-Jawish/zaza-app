import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zaza_app/config/routes/app_router.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:zaza_app/features/authentication/presentation/pages/login_page.dart';

import '../../../../core/utils/gen/assets.gen.dart';
class SplashPageBody extends StatefulWidget {
  const SplashPageBody({Key? key}) : super(key: key);

  @override
  State<SplashPageBody> createState() => _SplashPagebodyState();
}

class _SplashPagebodyState extends State<SplashPageBody>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    initSlidingAnimation();
    navigateToHome();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeTransition(
            opacity: fadeAnimation,
            child: Image.asset(
              Assets.images.logos.logoWhite512.path,
              width: 300,
              height: 300,
            ),
          ),
        ],
      ),
    );
  }

  void initSlidingAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);

    animationController.forward();
  }

  void navigateToHome() {
    Future.delayed(
      const Duration(seconds: 2),
          () {
        GoRouter.of(context).pushReplacement(AppRouter.kLoginPage);
      },
    );
  }
}
