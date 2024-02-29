import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:zaza_app/features/categories/data/data_sources/category_api_service.dart';
import 'package:zaza_app/features/categories/data/repository/category_repo_impl.dart';
import 'package:zaza_app/features/categories/domain/repository/category_repo.dart';
import 'package:zaza_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:zaza_app/features/categories/presentation/bloc/category_bloc.dart';
import 'package:zaza_app/features/discount/data/data_sources/discount_api_service.dart';
import 'package:zaza_app/features/discount/domain/repository/discount_repo.dart';
import 'package:zaza_app/features/discount/domain/usecases/get_discount_usecase.dart';
import 'package:zaza_app/features/discount/presentation/bloc/discount_bloc.dart';

import 'config/config.dart';
import 'core/network/network_info.dart';
import 'core/utils/auth_interceptor.dart';
import 'core/utils/bloc_observer.dart';
import 'core/utils/cache_helper.dart';
import 'core/widgets/custom_toast.dart';
import 'features/authentication/data/data_sources/remote/auth_api_service.dart';
import 'features/authentication/data/repository/auth_repo_impl.dart';
import 'features/authentication/domain/repository/auth_repo.dart';
import 'features/authentication/domain/usecases/login_usecase.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/basket/data/data_sources/local/basket_database_service.dart';
import 'features/basket/data/data_sources/local/basket_database_service_impl.dart';
import 'features/basket/data/models/product_unit.dart';
import 'features/discount/data/repository/discount_repo_impl.dart';

final sl = GetIt.instance;

var token;

var routePath;

var limit = 6;

var limitSearch = 10000000;
var limitOrders = 10000000;

var refresh_token;
var user_id;
var user_name;

var isOnboarding = 'false';

var categoryId;

var productId;
var productName;

var orderId;

Locale? locale;
var languageCode;
var selectedLanguageValue;

String sort = 'newest';

Map<String, String> languagesList = {
  'Germany': 'de',
  'English': 'en',
  'Arabic': 'ar',
};

List<String> statusList = ['all', 'pending', 'approved', 'rejected'];

Future<void> initializeDependencies() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProductUnitAdapter());
  await Hive.openBox<ProductUnit>('productUnitBox');
  //final box = Hive.box<ProductUnit>('productUnitBox');
  sl.registerSingleton<Box<ProductUnit>>(
      Hive.box<ProductUnit>('productUnitBox'));

  // Bloc Observer

  Bloc.observer = MyBlocObserver();

  // Shared Preferences

  await CacheHelper.init();

  // Secure Storage

  SecureStorage.initStorage();

  token = await SecureStorage.readSecureData(key: 'token');

  isOnboarding = await SecureStorage.readSecureData(key: 'isOnboarding');

  refresh_token = await SecureStorage.readSecureData(key: 'refresh_token');

  user_id = await SecureStorage.readSecureData(key: 'user_id');

  user_name = await SecureStorage.readSecureData(key: 'user_name');

  languageCode = await SecureStorage.readSecureData(key: 'languageCode');

  if (languageCode == 'No data found!') {
    locale = Locale('de');
    languageCode = 'de';
    selectedLanguageValue = 1;
  } else if (languageCode == 'de') {
    locale = Locale('de');
    selectedLanguageValue = 1;
  } else if (languageCode == 'en') {
    locale = Locale('en');
    selectedLanguageValue = 2;
  } else {
    locale = Locale('ar');
    selectedLanguageValue = 3;
  }

  debugPrint('onboarding=$isOnboarding');
  debugPrint('token=$token');
  debugPrint('refreshTokenSave=$refresh_token');
  debugPrint('user_id=$user_id');
  debugPrint('user_name=$user_name');
  debugPrint('locale=${locale}');
  debugPrint('languageCode=${languageCode}');

  // Dio
  Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'language': languageCode,
      },
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  // Access and Refresh Token
  dio.interceptors.add(AuthInterceptor(dio));

  // init dio
  sl.registerSingleton<Dio>(dio);

  // Register instances of FirebaseFirestore and FirebaseAuth and GoogleSignIn and FacebookAuth
  //sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  //sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  //sl.registerSingleton<GoogleSignIn>(GoogleSignIn());
  //sl.registerSingleton<FacebookAuth>(FacebookAuth.instance);

  // Dependencies

  sl.registerSingleton<BasketLocalDatabaseService>(
      BasketLocalDatabaseServiceImpl(
    box: sl<Box<ProductUnit>>(),
  ));

  sl.registerSingleton<AuthApiService>(AuthApiService(sl()));
  sl.registerSingleton<DiscountApiService>(DiscountApiService(sl()));
  sl.registerSingleton<CategoryApiService>(CategoryApiService(sl()));

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl()));
  sl.registerSingleton<DiscountRepository>(DiscountRepositoryImpl(sl()));
  sl.registerSingleton<CategoryRepository>(CategoryRepositoryImpl(sl()));

  // UseCases
  sl.registerSingleton<LoginUseCase>(LoginUseCase(sl()));
  sl.registerSingleton<GetDiscountUseCase>(GetDiscountUseCase(sl()));
  sl.registerSingleton<GetCategoriesUseCase>(GetCategoriesUseCase(sl()));

  // Network
  sl.registerSingleton<NetworkInfo>(
    NetworkInfoImpl(InternetConnectionChecker()),
  );

  // Bloc
  sl.registerFactory<AuthBloc>(() => AuthBloc(
        sl<LoginUseCase>(),
        sl<NetworkInfo>(),
      ));
  sl.registerFactory<DiscountBloc>(() => DiscountBloc(
        sl<GetDiscountUseCase>(),
        sl<NetworkInfo>(),
      ));
  sl.registerFactory<CategoryBloc>(() => CategoryBloc(
        sl<GetCategoriesUseCase>(),
        sl<NetworkInfo>(),
      ));
  //sl.registerFactory<HomeBloc>(() => HomeBloc(sl<NetworkInfo>()));
  //sl.registerFactory<CategoryBloc>(() => CategoryBloc(sl<NetworkInfo>()));
}