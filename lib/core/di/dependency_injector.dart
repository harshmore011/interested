import 'package:get_it/get_it.dart';
import 'package:interested/core/routes/app_router.dart';
import 'package:interested/core/theme/app_theme.dart';
import 'package:interested/features/onboarding/domain/usecases/get_onboarding_data_usecase.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../features/onboarding/data/datasources/onboarding_datasource.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

void injectDependencies() {

  // Core

  // Theme
  sl.registerLazySingleton<AppTheme>(() => AppTheme());
  // Routes
  sl.registerLazySingleton<AppRouter>(() => AppRouter());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  // External
  sl.registerLazySingleton(() => InternetConnection());

  // Onboarding
  // UseCases
  sl.registerLazySingleton(() => GetOnboardingDataUseCase(sl()));
  // Repositories
  sl.registerLazySingleton<OnboardingRepository>(() => OnboardingRepositoryImpl(networkInfo: sl(), onboardingDataSource: sl()));

  sl.registerLazySingleton<OnboardingDataSource>(() => OnboardingDataSourceImpl());


}