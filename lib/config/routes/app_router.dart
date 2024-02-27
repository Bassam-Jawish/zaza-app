import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zaza_app/config/routes/route_animation.dart';
import 'package:zaza_app/features/onboarding/presentation/pages/onboarding_page.dart';

import '../../features/authentication/presentation/pages/forgot_password_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/base/presentation/pages/base.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../injection_container.dart';

abstract class AppRouter {
  static const kLoginPage = '/login';
  static const kRegisterPage = 'register';
  static const kForgotPasswordPage = 'forgot_password';
  static const kCreatePasswordPage = 'create_password';
  static const kOnboardingPage = '/onboarding';
  static const kBasePage = '/base';
  static const kMessagesPage = 'messages';
  static const kTopExpertsPage = 'top_experts';
  static const kExpertDetailsPage = 'expert_details';
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  /*
  // For base bottom nav bar pages
  static final _shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorMessages =
      GlobalKey<NavigatorState>(debugLabel: 'shellMessages');
  */

  static bool _splashScreenShown = false;

  static final router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder: (context, state) {
          _splashScreenShown = true;
          return const MaterialPage(child: SplashPage());
        },
      ),
      GoRoute(
        path: kOnboardingPage,
        name: 'onboarding',
        pageBuilder: (context, state) {
          _splashScreenShown = true;
          return const MaterialPage(child: OnboardingPage());
        },
      ),
      GoRoute(
        path: kLoginPage,
        name: 'login',
        pageBuilder: (context, state) {
          _splashScreenShown = true;
          return const MaterialPage(child: LoginPage());
        },
        routes: [
          GoRoute(
            path: kForgotPasswordPage,
            name: 'forgot_password',
            pageBuilder: (context, state) =>
                slideTransition(const ForgotPasswordPage()),
            routes: [
              /*GoRoute(
  path: '$kVerificationForgotPage/:email',
  name: 'verification_forgot',
  pageBuilder: (context, state) => slideTransition(
  VerificationSendPage(
  email: state.pathParameters['email']!.toString() ?? ''),
  ),
  ),*/
            ],
          ),
        ],
        /*
      GoRoute(
        path: kLoginPage,
        name: 'login',
        pageBuilder: (context, state) {
          return const MaterialPage(child: LoginPage());
        },
        routes: [
          GoRoute(
              path: kRegisterPage,
              name: 'register',
              pageBuilder: (context, state) =>
                  slideTransition(const RegisterPage()),
              routes: [
                GoRoute(
                    path: '$kVerificationRegisterPage/:email',
                    name: 'verification_register',
                    pageBuilder: (context, state) => slideTransition(
                          VerificationSendPage(
                              email:
                                  state.pathParameters['email']!.toString() ??
                                      ''),
                        )),
              ]),
          GoRoute(
            path: kForgotPasswordPage,
            name: 'forgot_password',
            pageBuilder: (context, state) =>
                slideTransition(const ForgotPasswordPage()),
            routes: [
              GoRoute(
                path: '$kVerificationForgotPage/:email',
                name: 'verification_forgot',
                pageBuilder: (context, state) => slideTransition(
                  VerificationSendPage(
                      email: state.pathParameters['email']!.toString() ?? ''),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: kBasePage,
        name: 'base',
        pageBuilder: (context, state) {
          return const MaterialPage(child: BasePage());
        },
        routes: [
          GoRoute(
            path: kTopExpertsPage,
            name: 'top_experts',
            pageBuilder: (context, state) =>
                slideTransition(const TopExpertsPage()),
            routes: [
              GoRoute(
                  path: kExpertDetailsPage,
                  name: 'expert_details',
                  pageBuilder: (context, state) =>
                      slideTransition(const ExpertDetails()),
                  routes: const [

                  ]
              ),
            ]
          ),
        ],
      ),
*/
        // If want to keep bottom nav bar in each page
        /*
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BasePage(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: kHomePage,
                name: "home",
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    const MaterialPage(child: HomePage()),
                routes: [
                  GoRoute(
                    path: kTopExpertsPage,
                    name: 'topExpertsPage',
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      child: const TopExpertsPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMessages,
            routes: <RouteBase>[
              GoRoute(
                path: kMessagesPage,
                name: "messages",
                builder: (BuildContext context, GoRouterState state) =>
                    const MessagesPage(),
              ),
            ],
          ),
        ],
      ),
      */
      ),
      GoRoute(
        path: kBasePage,
        name: 'base',
        pageBuilder: (context, state) {
          return const MaterialPage(child: BasePage());
        },
        routes: [],
      ),
    ],
    redirect: (context, state) {
      debugPrint(state.fullPath);
      if (!_splashScreenShown) {
        return null;
      }
      if (isOnboarding == 'No data found!') {
        return kOnboardingPage;
      }
      if (token == 'No data found!' && state.fullPath == '/base') {
        return kLoginPage;
      }
      return null;
    },
  );
}
