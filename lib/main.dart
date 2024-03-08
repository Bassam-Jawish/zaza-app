import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/features/discount/presentation/bloc/discount_bloc.dart';

import 'config/routes/app_router.dart';
import 'config/theme/app_themes.dart';
import 'features/product/presentation/bloc/product/product_bloc.dart';
import 'injection_container.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  await initializeDependencies();
  configLoading();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (BuildContext context) => sl()),
        BlocProvider<DiscountBloc>(
            create: (BuildContext context) =>
            sl()
        ),
        BlocProvider<ProductBloc>(
          create: (BuildContext context) =>
              sl(),
        ),
        BlocProvider<BasketBloc>(
          create: (BuildContext context) =>
              sl(),
        ),
        BlocProvider<OrderBloc>(
          create: (BuildContext context) =>
              sl(),
        ),
        BlocProvider<SettingsBloc>(
          create: (BuildContext context) =>
              sl(),

        ),
        BlocProvider<ProfileBloc>(
          create: (BuildContext context) =>
              sl(),
        ),
        //BlocProvider<HomeBloc>(create: (BuildContext context) => sl()),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return MaterialApp.router(
                builder: EasyLoading.init(),/*(context, child) {
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
          );
        },
      ),
    );
  }
}
