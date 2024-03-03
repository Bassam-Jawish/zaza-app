import 'package:zaza_app/features/discount/presentation/bloc/discount_bloc.dart';
import 'package:zaza_app/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:zaza_app/features/product/presentation/bloc/new_product/new_product_bloc.dart';
import 'core/app_export.dart';
import 'features/product/presentation/bloc/product/product_bloc.dart';

final sl = GetIt.instance;

var token;

var routePath;

var limit = 10;

var limitForProductsInHome = 10;

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
        sl<AddToFavoritesUseCase>(),
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
