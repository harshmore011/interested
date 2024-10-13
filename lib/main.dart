import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interested/core/di/dependency_injector.dart';
import 'package:interested/core/utils/debug_logger.dart';
import 'package:interested/features/onboarding/presentation/blocs/onboarding_bloc.dart';
import 'core/routes/app_router.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  debugPrint("main: ");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 4000);
  await FirebaseStorage.instance.useStorageEmulator("localhost", 5001);
  // Firebase UI on :9200


  injectDependencies();

  runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<OnboardingBloc>()),
        ],
        child: const MyApp(),
      ));

      // const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    debugPrint("main: build()");

    return MaterialApp(
      title: 'Flutter Demo',
      theme: sl<AppTheme>().lightTheme,
      onGenerateRoute: (settings) => sl<AppRouter>().generateRoute(settings),
    );
  }
}
