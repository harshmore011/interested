import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';

import '../../features/authentication/data/datasources/authentication_datasource.dart';
import '../../features/authentication/data/repositories/authentication_repository_impl.dart';
import '../../features/authentication/domain/repositories/authentication_repository.dart';
import '../../features/authentication/domain/usecases/anonymous_sign_in_usecase.dart';
import '../../features/authentication/domain/usecases/anonymous_to_user_usecase.dart';
import '../../features/authentication/domain/usecases/forgot_password_usecase.dart';
import '../../features/authentication/domain/usecases/publisher_sign_in_usecase.dart';
import '../../features/authentication/domain/usecases/publisher_sign_up_usecase.dart';
import '../../features/authentication/domain/usecases/sign_out_Usecasse.dart';
import '../../features/authentication/domain/usecases/user_sign_in_usecase.dart';
import '../../features/authentication/domain/usecases/user_sign_up_usecase.dart';
import '../../features/authentication/domain/usecases/verify_email_usecase.dart';
import '../../features/authentication/presentation/blocs/authentication_bloc.dart';
import '../../features/onboarding/data/datasources/onboarding_datasource.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/get_onboarding_data_usecase.dart';
import '../../features/onboarding/presentation/blocs/onboarding_bloc.dart';
import '../network/network_info.dart';
import '../routes/app_router.dart';
import '../theme/app_theme.dart';

final sl = GetIt.instance;

void injectDependencies() {

  /// Core

  // Logger
  sl.registerLazySingleton<Logger>(() => Logger(level: Level.debug));

  // Theme
  sl.registerLazySingleton<AppTheme>(() => AppTheme());
  // Routes
  sl.registerLazySingleton<AppRouter>(() => AppRouter());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  // External
  sl.registerLazySingleton(() => InternetConnection());

  /// ONBOARDING
  // Bloc
  sl.registerFactory(() => OnboardingBloc(getOnboardingDataUseCase: sl()));
  // UseCases
  sl.registerLazySingleton(() => GetOnboardingDataUseCase(sl()));
  // Repositories
  sl.registerLazySingleton<OnboardingRepository>(() => OnboardingRepositoryImpl(networkInfo: sl()
      , onboardingDataSource: sl()));
  // Data Source
  sl.registerLazySingleton<OnboardingDataSource>(() => OnboardingDataSourceImpl());

  /// AUTHENTICATION
  //Bloc
  sl.registerFactory(() => AuthenticationBloc(anonymousSignInUseCase: sl()
      , anonymousToUserUseCase: sl()
      , userSignUpUseCase: sl()
      , userSignInUseCase: sl()
      , publisherSignUpUseCase: sl()
      , publisherSignInUseCase: sl()
      , verifyEmailUseCase: sl()
      // , forgotPasswordUseCase: sl()
      , signOutUseCase: sl()));
  //UseCases
  sl.registerSingleton(() => AnonymousSignInUseCase(sl()));
  sl.registerSingleton(() => AnonymousToUserUseCase(sl()));
  sl.registerSingleton(() => UserSignUpUseCase(sl()));
  sl.registerSingleton(() => UserSignInUseCase(sl()));
  sl.registerSingleton(() => PublisherSignUpUseCase(sl()));
  sl.registerSingleton(() => PublisherSignInUseCase(sl()));
  sl.registerSingleton(() => VerifyEmailUseCase(sl()));
  sl.registerSingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerSingleton(() => SignOutUseCase(sl()));
  //Repositories
  sl.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepositoryImpl(networkInfo: sl()
      , authenticationDataSource: sl()));
  //Data Source
  sl.registerLazySingleton<AuthenticationDataSource>(() => AuthenticationDataSourceImpl());

}