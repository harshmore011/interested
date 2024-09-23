import 'package:get_it/get_it.dart';
import 'package:interested/core/routes/app_router.dart';
import 'package:interested/core/theme/app_theme.dart';

final sl = GetIt.instance;

void injectDependencies() {

  // Core

  // Theme
  sl.registerLazySingleton(() => AppTheme());
  // Routes
  sl.registerLazySingleton<AppRouter>(() => AppRouter());

}