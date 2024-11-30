
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';

import '../../features/article/article_interaction/data/datasources/article_interaction_datasource.dart';
import '../../features/article/article_interaction/data/repositories/article_interaction_repository_impl.dart';
import '../../features/article/article_interaction/domain/repositories/article_interaction_repository.dart';
import '../../features/article/article_interaction/domain/usecases/add_reply_to_comment_usecase.dart';
import '../../features/article/article_interaction/domain/usecases/comment_on_article_usecase.dart';
import '../../features/article/article_interaction/domain/usecases/get_home_article_page_usecase.dart';
import '../../features/article/article_interaction/domain/usecases/view_article_usecase.dart';
import '../../features/article/article_interaction/domain/usecases/like_article_usecase.dart';
import '../../features/article/article_interaction/domain/usecases/save_article_usecase.dart';
import '../../features/article/article_interaction/domain/usecases/unlike_article_usecase.dart';
import '../../features/article/article_interaction/domain/usecases/unsave_article_usecase.dart';
import '../../features/article/article_interaction/presentation/blocs/article_interaction_bloc.dart';
import '../../features/article/article_management/domain/usecases/get_draft_articles_usecase.dart';
import '../../features/article/article_management/domain/usecases/get_published_articles_usecase.dart';
import '../../features/article/article_management/domain/usecases/get_scheduled_articles_usecase.dart';
import '../../features/article/article_management/domain/usecases/publish_article_usecase.dart';
import '../../features/article/article_management/domain/usecases/schedule_publish_article_usecase.dart';
import '../../features/article/article_management/domain/usecases/unpublish_article_usecase.dart';
import '../../features/article/article_management/domain/usecases/update_article_usecase.dart';
import '../../features/article/article_management/domain/usecases/create_draft_article_usecase.dart';
import '../../features/article/article_management/domain/usecases/delete_article_usecase.dart';
import '../../features/article/article_management/data/datasources/article_management_datasource.dart';
import '../../features/article/article_management/data/repositories/article_management_repository_impl.dart';
import '../../features/article/article_management/domain/repositories/article_management_repository.dart';
import '../../features/article/article_management/presentation/blocs/article_management_bloc.dart';
import '../../features/authentication/data/datasources/authentication_datasource.dart';
import '../../features/authentication/data/repositories/authentication_repository_impl.dart';
import '../../features/authentication/domain/repositories/authentication_repository.dart';
import '../../features/authentication/domain/usecases/anonymous_sign_in_usecase.dart';
import '../../features/authentication/domain/usecases/anonymous_to_user_usecase.dart';
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
import '../utils/shared_pref_helper.dart';

final sl = GetIt.instance;

Future<void> injectDependencies() async {

  // Logger
  sl.registerLazySingleton<Logger>(() => Logger(level: Level.debug));

  /// Core
  await SharedPrefHelper.reloadCurrentUser();

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
  sl.registerLazySingleton(() => AnonymousSignInUseCase(sl()));
  sl.registerLazySingleton(() => AnonymousToUserUseCase(sl()));
  sl.registerLazySingleton(() => UserSignUpUseCase(sl()));
  sl.registerLazySingleton(() => UserSignInUseCase(sl()));
  sl.registerLazySingleton(() => PublisherSignUpUseCase(sl()));
  sl.registerLazySingleton(() => PublisherSignInUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  // sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  //Repositories
  sl.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepositoryImpl(networkInfo: sl()
      , authenticationDataSource: sl()));
  //Data Source
  sl.registerLazySingleton<AuthenticationDataSource>(() => AuthenticationDataSourceImpl());

  /// PUBLISHER ARTICLE MANAGEMENT
  // Bloc
  sl.registerFactory(() => ArticleManagementBloc(getDraftArticlesUseCase: sl(),
      getPublishedArticlesUseCase: sl(),
      getScheduledArticlesUseCase: sl(),
      publishArticleUseCase: sl(),
      deleteArticleUseCase: sl(),
      schedulePublishArticleUseCase: sl(),
      unpublishArticleUseCase: sl(),
      updateArticleUseCase: sl(),
      createDraftArticleUseCase: sl()));
  // UseCases
  sl.registerLazySingleton(() => GetDraftArticlesUseCase(sl()));
  sl.registerLazySingleton(() => GetPublishedArticlesUseCase(sl()));
  sl.registerLazySingleton(() => GetScheduledArticlesUseCase(sl()));
  sl.registerLazySingleton(() => PublishArticleUseCase(sl()));
  sl.registerLazySingleton(() => DeleteArticleUseCase(sl()));
  sl.registerLazySingleton(() => SchedulePublishArticleUseCase(sl()));
  sl.registerLazySingleton(() => UnpublishArticleUseCase(sl()));
  sl.registerLazySingleton(() => UpdateArticleUseCase(sl()));
  sl.registerLazySingleton(() => CreateDraftArticleUseCase(sl()));
  // Repositories
  sl.registerLazySingleton<ArticleManagementRepository>(() => ArticleManagementRepositoryImpl(networkInfo: sl()
      , articleManagementDataSource: sl()));
  //Data Source
  sl.registerLazySingleton<ArticleManagementDataSource>(() => ArticleManagementDataSourceImpl());


  /// ARTICLE INTERACTION
  // Bloc
  sl.registerFactory(() => ArticleInteractionBloc(likeArticleUseCase: sl(),
  viewArticleUseCase: sl(),
  unlikeArticleUseCase: sl(),
  commentOnArticleUseCase: sl(),
  addReplyToCommentUseCase: sl(),
  saveArticleUseCase: sl(),
  unsaveArticleUseCase: sl(),
  getArticlesUseCase: sl()));

  // UseCases
  sl.registerLazySingleton(() => ViewArticleUseCase(sl()));
  sl.registerLazySingleton(() => LikeArticleUseCase(sl()));
  sl.registerLazySingleton(() => UnlikeArticleUseCase(sl()));
  sl.registerLazySingleton(() => CommentOnArticleUseCase(sl()));
  sl.registerLazySingleton(() => AddReplyToCommentUseCase(sl()));
  sl.registerLazySingleton(() => SaveArticleUseCase(sl()));
  sl.registerLazySingleton(() => UnSaveArticleUseCase(sl()));
  sl.registerLazySingleton(() => GetHomeArticlePageUseCase(sl()));
  // Repositories
  sl.registerLazySingleton<ArticleInteractionRepository>(() => ArticleInteractionRepositoryImpl(networkInfo: sl()
      , dataSource: sl()));
  //Data Source
  sl.registerLazySingleton<ArticleInteractionDataSource>(() => ArticleInteractionDataSourceImpl());

}
