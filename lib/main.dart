import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/dependency_injector.dart';
import 'core/routes/app_router.dart';
import 'core/utils/debug_logger.dart';
import 'core/utils/shared_pref_helper.dart';
import 'features/article/article_management/presentation/blocs/article_management_bloc.dart';
import 'features/authentication/presentation/blocs/authentication_bloc.dart';
import 'features/onboarding/presentation/blocs/onboarding_bloc.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 4000);
  await FirebaseStorage.instance.useStorageEmulator("localhost", 5001);
  //    "hosting": {
//      "port": 7000
//    },

  // "hosting": {
  // "source": ".",
  // "ignore": [
  // "firebase.json",
  // "**/.*",
  // "**/node_modules/**"
  // ],
  // "frameworksBackend": {
  // "region": "asia-east1"
  // }
  // }
  // Firebase UI on :9200


  await injectDependencies();
  logger.log("main:", "");

  final String initialRoute = await SharedPrefHelper.decideInitialRoute();
  logger.log("main:", "initialRoute: $initialRoute");

  runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<OnboardingBloc>()),
          BlocProvider(create: (context) => sl<AuthenticationBloc>()),
          BlocProvider(create: (context) => sl<ArticleManagementBloc>()),
        ],
        child: MyApp(initialRoute: initialRoute,),
      ));

      // const MyApp());
}


class MyApp extends StatelessWidget {

  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {

    debugPrint("main: build()");

    return MaterialApp(
      title: 'interested!',
      theme: sl<AppTheme>().lightTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => sl<AppRouter>().generateRoute(settings, initialRoute),
      initialRoute: this.initialRoute,
    );
  }

}
