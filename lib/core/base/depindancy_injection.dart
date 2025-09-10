import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../core/base/route_generator.dart';
import '../../scr/currencies/data/datasources/remote/currencies_remote_data_source.dart';
import '../../scr/currencies/data/datasources/remote/currencies_remote_data_source_impl.dart';
import '../../scr/currencies/data/repository/currencies_repository_impl.dart';
import '../../scr/currencies/domain/repository/currencies_repository.dart';
import '../../scr/currencies/domain/usecases/currencies_usecase.dart';
import '../../scr/currencies/presentation/controller/currencies_view_model.dart';
import '../../scr/historical/data/datasources/remote/historical_remote_data_source.dart';
import '../../scr/historical/data/datasources/remote/historical_remote_data_source_impl.dart';
import '../../scr/historical/data/repository/historical_repository_impl.dart';
import '../../scr/historical/domain/repository/historical_repository.dart';
import '../../scr/historical/domain/usecases/historical_usecase.dart';
import '../../scr/historical/presentation/controller/historical_view_model.dart';
import '../../scr/home/presentation/controller/home_view_model.dart';
import '../../scr/splash/presentation/controller/splash_screen_view_model.dart';
import '../../scr/transfer/data/datasources/remote/transfer_remote_data_source.dart';
import '../../scr/transfer/data/datasources/remote/transfer_remote_data_source_impl.dart';
import '../../scr/transfer/data/repository/transfer_repository_impl.dart';
import '../../scr/transfer/domain/repository/transfer_repository.dart';
import '../../scr/transfer/domain/usecases/transfer_usecase.dart';
import '../../scr/transfer/presentation/controller/transfer_view_model.dart';
import '../common/config.dart';
import '../util/api_interceptor/api_interceptor.dart';
import '../util/localization/cubit/localization_cubit.dart';
import '../util/network/network_info.dart';
import '../util/network_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => RouteGenerator(routs: sl()));
  sl.registerFactory(() => LocalizationCubit());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton<NetworkService>(() => NetworkServiceImpl());
  sl.registerLazySingleton(
    () =>
        Dio(BaseOptions(headers: Config.headers))
          ..interceptors.add(ApiInterceptor()),
  );

  /// VIEW MODELS
  sl.registerFactory(() => SplashScreenViewModel());
  sl.registerFactory(() => HomeViewModel());
  sl.registerFactory(
    () => CurrenciesViewModel(useCase: sl(), networkInfo: sl()),
  );
  sl.registerFactory(() => TransferViewModel(useCase: sl(), networkInfo: sl()));
  sl.registerFactory(
    () => HistoricalViewModel(useCase: sl(), networkInfo: sl()),
  );

  /// USECASES
  sl.registerLazySingleton(() => CurrenciesUseCase(sl()));
  sl.registerLazySingleton(() => TransferUseCase(sl()));
  sl.registerLazySingleton(() => HistoricalUseCase(sl()));

  /// REPOSITORIES
  sl.registerLazySingleton<CurrenciesRepository>(
    () => CurrenciesRepositoryImp(dataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<TransferRepository>(
    () => TransferRepositoryImp(dataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<HistoricalRepository>(
    () => HistoricalRepositoryImp(dataSource: sl(), networkInfo: sl()),
  );

  /// DATA SOURCE
  sl.registerLazySingleton<CurrenciesRemoteDataSource>(
    () => CurrenciesRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TransferRemoteDataSource>(
    () => TransferRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<HistoricalRemoteDataSource>(
    () => HistoricalRemoteDataSourceImpl(sl()),
  );
}
