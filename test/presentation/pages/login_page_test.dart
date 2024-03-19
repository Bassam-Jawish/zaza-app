import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zaza_app/config/routes/app_router.dart';
import 'package:zaza_app/config/theme/app_themes.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/features/authentication/domain/entities/user.dart';
import 'package:zaza_app/features/authentication/presentation/widgets/login_body.dart';
import 'package:zaza_app/injection_container.dart';
import 'package:zaza_app/l10n/l10n.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

class MockBasketBloc extends MockBloc<BasketEvent, BasketState>
    implements BasketBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockSettingsBloc mockSettingsBloc;
  late MockBasketBloc mockBasketBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockSettingsBloc = MockSettingsBloc();
    mockBasketBloc = MockBasketBloc();
    HttpOverrides.global = null;
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (BuildContext context) => mockAuthBloc),
        BlocProvider<BasketBloc>(
            create: (BuildContext context) => mockBasketBloc),
        BlocProvider<SettingsBloc>(
          create: (BuildContext context) => mockSettingsBloc,
        ),
        //BlocProvider<HomeBloc>(create: (BuildContext context) => sl()),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp.router(
            builder: EasyLoading.init(),
            /*(context, child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                data: data.copyWith(textScaler: TextScaler.linear(1.0)),
                child: child!,
              );
            },*/
            locale: locale,
            supportedLocales: L10n.all,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            title: 'Zaza App',
            theme: theme(),
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  const testUserInfoEntity = UserInfoEntity(
    accessToken: 'accessToken',
    refreshToken: 'refreshToken',
    userEntity: UserEntity(
        userId: 1,
        userName: 'testUser',
        name: 'Test User',
        email: 'test@example.com'),
  );

  final state = AuthState().copyWith(
      authStatus: AuthStatus.initial,
      isPasswordVis: false,
      isForgotPasswordLoading: false,
      isValidateResetPasswordLoading: false,
      isResetPasswordLoading: false);

  final state2 = BasketState().copyWith(
      basketStatus: BasketStatus.initial,
      subTotal: 0.0,
      total: 0.0,
      basketProductsList: [],
      productUnitHelper: [],
      isLoading: false,quantityController: TextEditingController(), chosenQuantity: '');

  /*testWidgets(
    'text field should trigger state to change from empty to loading',
    (widgetTester) async {
      //arrange
      when(()=> mockAuthBloc.state).thenReturn(state.copyWith(
          authStatus: AuthStatus.initial,
          isPasswordVis: false,
          isForgotPasswordLoading: false,
          isValidateResetPasswordLoading: false,
          isResetPasswordLoading: false));

      //act
      await widgetTester.pumpWidget(_makeTestableWidget(const LoginPage()));
      var textField = find.byWidget(TextFormField());
      expect(textField, findsOneWidget);
      await widgetTester.enterText(find.byKey(const Key('username_field')), 'username');
      await widgetTester.enterText(find.byKey(const Key('password_field')), 'password');
      await widgetTester.pump();
      expect(find.text('username'), findsOneWidget);
      expect(find.text('password'), findsOneWidget);
    },
  );*/

  testWidgets(
    'should show progress indicator when state is loading',
    (widgetTester) async {
      //arrange
      when(() => mockAuthBloc.state)
          .thenReturn(state.copyWith(authStatus: AuthStatus.loading));
      /*when(() => mockBasketBloc.state)
          .thenReturn(state.copyWith(ba));*/
      //act
      // await widgetTester.tap(finder)
      await widgetTester.pumpWidget(_makeTestableWidget(LoginBody()));
      await widgetTester.pumpAndSettle();

      //assert
      expect(find.byKey(Key('spin')), findsOneWidget);
    },
  );

  /*
  not important because nothing to show with login
  testWidgets(
    'should show widget contain User data when state is Login loaded',
    (widgetTester) async {
      //arrange
      when(()=> mockAuthBloc.state).thenReturn(const AuthLoaded(testUserInfoEntity));

      //act
      await widgetTester.pumpWidget(_makeTestableWidget(const LoginPage()));

      //assert
      expect(find.byKey(const Key('Auth_data')), findsOneWidget);
    },
  );*/
}
