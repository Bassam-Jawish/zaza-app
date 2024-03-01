import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:zaza_app/features/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:zaza_app/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:zaza_app/features/authentication/domain/usecases/validate_reset_password_usecase.dart';
import 'package:zaza_app/features/categories/data/data_sources/category_api_service.dart';
import 'package:zaza_app/features/categories/data/repository/category_repo_impl.dart';
import 'package:zaza_app/features/categories/domain/repository/category_repo.dart';
import 'package:zaza_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:zaza_app/features/categories/presentation/bloc/category_bloc.dart';
import 'package:zaza_app/features/discount/data/data_sources/discount_api_service.dart';
import 'package:zaza_app/features/discount/domain/repository/discount_repo.dart';
import 'package:zaza_app/features/discount/domain/usecases/get_discount_usecase.dart';
import 'package:zaza_app/features/discount/presentation/bloc/discount_bloc.dart';
import 'package:zaza_app/features/favorite/domain/usecases/add_to_favorites_usecase.dart';
import 'package:zaza_app/features/settings/presentation/bloc/settings_bloc.dart';

import 'config/config.dart';
import 'core/network/network_info.dart';
import 'core/utils/auth_interceptor.dart';
import 'core/utils/bloc_observer.dart';
import 'core/utils/cache_helper.dart';
import 'features/authentication/data/data_sources/remote/auth_api_service.dart';
import 'features/authentication/data/repository/auth_repo_impl.dart';
import 'features/authentication/domain/repository/auth_repo.dart';
import 'features/authentication/domain/usecases/login_usecase.dart';
import 'features/authentication/domain/usecases/reset_password_usecase.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/basket/data/data_sources/local/basket_database_service.dart';
import 'features/basket/data/data_sources/local/basket_database_service_impl.dart';
import 'features/basket/data/data_sources/remote/basket_api_service.dart';
import 'features/basket/data/models/product_unit.dart';
import 'features/basket/data/repository/basket_repo_impl.dart';
import 'features/basket/domain/repository/basket_repo.dart';
import 'features/basket/domain/usecases/add_to_basket_usecase.dart';
import 'features/basket/domain/usecases/delete_basket_usecase.dart';
import 'features/basket/domain/usecases/edit_basket_usecase.dart';
import 'features/basket/domain/usecases/get_basket_usecase.dart';
import 'features/basket/domain/usecases/get_id_quantity_usecase.dart';
import 'features/basket/domain/usecases/remove_one_basket_usecase.dart';
import 'features/basket/domain/usecases/send_order_usecase.dart';
import 'features/basket/presentation/bloc/basket_bloc.dart';
import 'features/discount/data/repository/discount_repo_impl.dart';
import 'features/favorite/data/data_sources/favorite_api_service.dart';
import 'features/favorite/data/repository/favorite_repo_impl.dart';
import 'features/favorite/domain/repository/favorite_repo.dart';
import 'features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'features/favorite/presentation/bloc/favorite_bloc.dart';
import 'features/orders/data/data_sources/order_api_service.dart';
import 'features/orders/data/repository/order_repo_impl.dart';
import 'features/orders/domain/repository/order_repo.dart';
import 'features/orders/domain/usecases/get_order_details_usecase.dart';
import 'features/orders/domain/usecases/get_orders_usecase.dart';
import 'features/orders/presentation/bloc/order_bloc.dart';
import 'features/product/data/data_sources/product_api_service.dart';
import 'features/product/data/repository/product_repo_impl.dart';
import 'features/product/domain/repository/product_repo.dart';
import 'features/product/domain/usecases/get_product_info_usecase.dart';
import 'features/product/domain/usecases/seacrh_products_usecase.dart';
import 'features/product/presentation/bloc/new_product/new_product_bloc.dart';
import 'features/product/presentation/bloc/product/product_bloc.dart';
import 'features/profile/data/data_sources/profile_api_service.dart';
import 'features/profile/data/repository/profile_repo_impl.dart';
import 'features/profile/domain/repository/profile_repo.dart';
import 'features/profile/domain/usecases/create_phone_usecase.dart';
import 'features/profile/domain/usecases/delete_phone_usecase.dart';
import 'features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'features/profile/presentation/bloc/remote/profile_bloc.dart';

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
  dio.interceptors.add(RefreshTokenInterceptor());

  // init dio
  sl.registerSingleton<Dio>(dio);

  // Dependencies (Services)
  sl.registerSingleton<BasketLocalDatabaseService>(
      BasketLocalDatabaseServiceImpl(
    box: sl<Box<ProductUnit>>(),
  ));

  sl.registerSingleton<AuthApiService>(AuthApiService(sl()));
  sl.registerSingleton<DiscountApiService>(DiscountApiService(sl()));
  sl.registerSingleton<CategoryApiService>(CategoryApiService(sl()));
  sl.registerSingleton<BasketApiService>(BasketApiService(sl()));
  sl.registerSingleton<FavoriteApiService>(FavoriteApiService(sl()));
  sl.registerSingleton<OrderApiService>(OrderApiService(sl()));
  sl.registerSingleton<ProductApiService>(ProductApiService(sl()));
  sl.registerSingleton<ProfileApiService>(ProfileApiService(sl()));

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl()));
  sl.registerSingleton<DiscountRepository>(DiscountRepositoryImpl(sl()));
  sl.registerSingleton<CategoryRepository>(CategoryRepositoryImpl(sl()));
  sl.registerSingleton<BasketRepository>(BasketRepositoryImpl(sl(), sl()));
  sl.registerSingleton<FavoriteRepository>(FavoriteRepositoryImpl(sl()));
  sl.registerSingleton<OrderRepository>(OrderRepositoryImpl(sl()));
  sl.registerSingleton<ProductRepository>(ProductRepositoryImpl(sl()));
  sl.registerSingleton<ProfileRepository>(ProfileRepositoryImpl(sl()));

  // UseCases
  sl.registerSingleton<LoginUseCase>(LoginUseCase(sl()));
  sl.registerSingleton<ForgotPasswordUseCase>(ForgotPasswordUseCase(sl()));
  sl.registerSingleton<ValidateResetPasswordUseCase>(
      ValidateResetPasswordUseCase(sl()));
  sl.registerSingleton<ResetPasswordUseCase>(ResetPasswordUseCase(sl()));
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase(sl()));
  sl.registerSingleton<GetDiscountUseCase>(GetDiscountUseCase(sl()));
  sl.registerSingleton<AddToFavoritesUseCase>(AddToFavoritesUseCase(sl()));
  sl.registerSingleton<GetCategoriesUseCase>(GetCategoriesUseCase(sl()));
  sl.registerSingleton<GetBasketUseCase>(GetBasketUseCase(sl()));
  sl.registerSingleton<GetIdQuantityBasketUseCase>(
      GetIdQuantityBasketUseCase(sl()));
  sl.registerSingleton<EditQuantityBasketUseCase>(
      EditQuantityBasketUseCase(sl()));
  sl.registerSingleton<AddToBasketUseCase>(AddToBasketUseCase(sl()));
  sl.registerSingleton<RemoveOneBasketUseCase>(RemoveOneBasketUseCase(sl()));
  sl.registerSingleton<DeleteBasketUseCase>(DeleteBasketUseCase(sl()));
  sl.registerSingleton<SendOrdersUseCase>(SendOrdersUseCase(sl()));
  sl.registerSingleton<GetFavoritesUseCase>(GetFavoritesUseCase(sl()));
  sl.registerSingleton<GetOrdersUseCase>(GetOrdersUseCase(sl()));
  sl.registerSingleton<GetOrderDetailsUseCase>(GetOrderDetailsUseCase(sl()));
  sl.registerSingleton<SearchProductsUseCase>(SearchProductsUseCase(sl()));
  sl.registerSingleton<GetProductInfoUseCase>(GetProductInfoUseCase(sl()));
  sl.registerSingleton<GetUserProfileUseCase>(GetUserProfileUseCase(sl()));
  sl.registerSingleton<CreatePhoneUseCase>(CreatePhoneUseCase(sl()));
  sl.registerSingleton<DeletePhoneUseCase>(DeletePhoneUseCase(sl()));

  // Network
  sl.registerSingleton<NetworkInfo>(
    NetworkInfoImpl(InternetConnectionChecker()),
  );

  // Bloc
  sl.registerFactory<AuthBloc>(() => AuthBloc(
        sl<LoginUseCase>(),
        sl<ForgotPasswordUseCase>(),
        sl<ValidateResetPasswordUseCase>(),
        sl<ResetPasswordUseCase>(),
        sl<LogoutUseCase>(),
        sl<NetworkInfo>(),
      ));
  sl.registerFactory<DiscountBloc>(() => DiscountBloc(
        sl<GetDiscountUseCase>(),
        sl<AddToFavoritesUseCase>(),
        sl<NetworkInfo>(),
      ));
  sl.registerFactory<CategoryBloc>(() => CategoryBloc(
        sl<GetCategoriesUseCase>(),
        sl<AddToFavoritesUseCase>(),
        sl<NetworkInfo>(),
      ));
  sl.registerFactory<BasketBloc>(() => BasketBloc(
        sl<GetBasketUseCase>(),
        sl<GetIdQuantityBasketUseCase>(),
        sl<EditQuantityBasketUseCase>(),
        sl<AddToBasketUseCase>(),
        sl<RemoveOneBasketUseCase>(),
        sl<DeleteBasketUseCase>(),
        sl<SendOrdersUseCase>(),
        sl<NetworkInfo>(),
      ));
  sl.registerFactory<FavoriteBloc>(() => FavoriteBloc(
        sl<GetFavoritesUseCase>(),
        sl<AddToFavoritesUseCase>(),
        sl<NetworkInfo>(),
      ));
  sl.registerFactory<OrderBloc>(() => OrderBloc(
        sl<GetOrdersUseCase>(),
        sl<GetOrderDetailsUseCase>(),
        sl<NetworkInfo>(),
      ));
  sl.registerFactory<NewProductBloc>(() => NewProductBloc(
        sl<SearchProductsUseCase>(),
        sl<AddToFavoritesUseCase>(),
        sl<NetworkInfo>(),
      ));
  sl.registerFactory<ProductBloc>(() => ProductBloc(
        sl<SearchProductsUseCase>(),
        sl<GetProductInfoUseCase>(),
        sl<NetworkInfo>(),
      ));
  sl.registerFactory<ProfileBloc>(() => ProfileBloc(
        sl<GetUserProfileUseCase>(),
        sl<CreatePhoneUseCase>(),
        sl<DeletePhoneUseCase>(),
        sl<NetworkInfo>(),
      ));
  sl.registerFactory<SettingsBloc>(() => SettingsBloc());
}
