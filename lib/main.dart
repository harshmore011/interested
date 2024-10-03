import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:interested/core/di/dependency_injector.dart';
import 'core/routes/app_router.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  debugPrint("main: ");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  injectDependencies();

  runApp(const MyApp());
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
