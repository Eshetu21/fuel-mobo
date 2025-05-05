import 'package:dio/dio.dart';
import 'package:fuel_finder/core/utils/token_services.dart';
import 'package:fuel_finder/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fuel_finder/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fuel_finder/features/auth/domain/repositories/auth_repository.dart';
import 'package:fuel_finder/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/signin_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/signup_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuel_finder/features/favorite/data/datasources/favorite_remote_data_source.dart';
import 'package:fuel_finder/features/favorite/data/repositories/favorite_repository_impl.dart';
import 'package:fuel_finder/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:fuel_finder/features/favorite/domain/usecases/get_favorite_usecase.dart';
import 'package:fuel_finder/features/favorite/domain/usecases/remove_favorite_usecase.dart';
import 'package:fuel_finder/features/favorite/domain/usecases/set_favorite_usecase.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:fuel_finder/features/feedback/data/datasources/feed_back_remote_datasource.dart';
import 'package:fuel_finder/features/feedback/data/repositories/feed_back_repository_impl.dart';
import 'package:fuel_finder/features/feedback/domain/repositories/feed_back_repository.dart';
import 'package:fuel_finder/features/feedback/domain/usecases/create_feed_back_usecase.dart';
import 'package:fuel_finder/features/feedback/domain/usecases/get_feed_back_usecase.dart';
import 'package:fuel_finder/features/feedback/presentation/bloc/feed_back_bloc.dart';
import 'package:fuel_finder/features/fuel_price/data/datasources/fuel_price_remote_repository.dart';
import 'package:fuel_finder/features/fuel_price/data/repositories/fuel_price_repository_impl.dart';
import 'package:fuel_finder/features/fuel_price/domain/repositories/fuel_price_repository.dart';
import 'package:fuel_finder/features/fuel_price/domain/usecases/get_fuel_price_usecase.dart';
import 'package:fuel_finder/features/fuel_price/presentation/bloc/fuel_price_bloc.dart';
import 'package:fuel_finder/features/gas_station/data/datasources/gas_station_remote_data_source.dart';
import 'package:fuel_finder/features/gas_station/data/repositories/gas_station_repository_impl.dart';
import 'package:fuel_finder/features/gas_station/domain/repositories/gas_repository.dart';
import 'package:fuel_finder/features/gas_station/domain/usecases/get_gas_station_usecase.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_bloc.dart';
import 'package:fuel_finder/features/map/presentation/bloc/geolocation_bloc.dart';
import 'package:fuel_finder/features/route/data/datasources/osrm_data_source.dart';
import 'package:fuel_finder/features/route/data/repositories/route_repository.dart';
import 'package:fuel_finder/features/route/presentation/bloc/route_bloc.dart';
import 'package:fuel_finder/features/user/data/datasources/user_remote_data_source.dart';
import 'package:fuel_finder/features/user/data/repositories/user_repository_impl.dart';
import 'package:fuel_finder/features/user/domain/repositories/user_repository.dart';
import 'package:fuel_finder/features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

void setUpDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => TokenService(sl()));

  // Auth

  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton(
    () => SignupUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => SigninUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => VerifyEmailUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => LogoutUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => AuthBloc(
      tokenService: sl<TokenService>(),
      signupUsecase: sl<SignupUsecase>(),
      signinUsecase: sl<SigninUsecase>(),
      verifyEmailUsecase: sl<VerifyEmailUsecase>(),
      logoutUsecase: sl<LogoutUsecase>(),
    ),
  );

  // User

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(tokenService: sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(userRemoteDataSource: sl<UserRemoteDataSource>()),
  );
  sl.registerLazySingleton(
    () => GetUserByIdUsecase(userRepository: sl<UserRepository>()),
  );
  sl.registerLazySingleton(
    () => UserBloc(getUserByIdUsecase: sl<GetUserByIdUsecase>()),
  );

  // Geo Location

  sl.registerLazySingleton(() => GeolocationBloc());

  // Route

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(<RouteRepository>() => OSRMDataSource(sl<Dio>()));
  sl.registerLazySingleton<RouteRepository>(
    () => RouteRepositoryImpl(sl<OSRMDataSource>()),
  );
  sl.registerLazySingleton(() => RouteRepository);
  sl.registerLazySingleton(() => RouteBloc(sl<RouteRepository>()));

  // Gas Stations

  sl.registerLazySingleton(
    () => GasStationRemoteDataSource(tokenService: sl()),
  );
  sl.registerLazySingleton<GasRepository>(
    () => GasStationRepositoryImpl(
      gasStationRemoteDataSource: sl<GasStationRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetGasStationUsecase(gasRepository: sl<GasRepository>()),
  );
  sl.registerLazySingleton(
    () => GasStationBloc(getGasStationUsecase: sl<GetGasStationUsecase>()),
  );

  // Favorites

  sl.registerLazySingleton(() => FavoriteRemoteDataSource(tokenService: sl()));

  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(
      favoriteRemoteDataSource: sl<FavoriteRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton(
    () => SetFavoriteUsecase(favoriteRepository: sl<FavoriteRepository>()),
  );
  sl.registerLazySingleton(
    () => RemoveFavoriteUsecase(favoriteRepository: sl<FavoriteRepository>()),
  );
  sl.registerLazySingleton(
    () => GetFavoriteUsecase(favoriteRepository: sl<FavoriteRepository>()),
  );
  sl.registerLazySingleton(
    () => FavoriteBloc(
      setFavoriteUsecase: sl<SetFavoriteUsecase>(),
      removeFavoriteUsecase: sl<RemoveFavoriteUsecase>(),
      getFavoriteUsecase: sl<GetFavoriteUsecase>(),
    ),
  );

  // Fuel Prices

  sl.registerLazySingleton(() => FuelPriceRemoteRepository(tokenService: sl()));
  sl.registerLazySingleton<FuelPriceRepository>(
    () => FuelPriceRepositoryImpl(
      fuelPriceRemoteRepository: sl<FuelPriceRemoteRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetFuelPriceUsecase(fuelPriceRepository: sl<FuelPriceRepository>()),
  );
  sl.registerLazySingleton(
    () => FuelPriceBloc(getFuelPriceUsecase: sl<GetFuelPriceUsecase>()),
  );

  // Feedbacks

  sl.registerLazySingleton(() => FeedBackRemoteDatasource(tokenService: sl()));
  sl.registerLazySingleton<FeedBackRepository>(
    () => FeedBackRepositoryImpl(
      feedBackRemoteDatasource: sl<FeedBackRemoteDatasource>(),
    ),
  );
  sl.registerLazySingleton(
    () => CreateFeedBackUsecase(feedBackRepository: sl<FeedBackRepository>()),
  );
  sl.registerLazySingleton(
    () => GetFeedBackUsecase(feedBackRepository: sl<FeedBackRepository>()),
  );
  sl.registerLazySingleton(
    () => FeedBackBloc(
      createFeedBackUsecase: sl<CreateFeedBackUsecase>(),
      getFeedBackUsecase: sl<GetFeedBackUsecase>(),
    ),
  );
}
