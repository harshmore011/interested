import 'package:flutter/material.dart';

import '../../features/article/article_management/presentation/pages/create_update_article_page.dart';
import '../../features/article/article_management/presentation/pages/publisher_home_page.dart';
import '../../features/authentication/presentation/pages/authentication_page.dart';
import '../../features/authentication/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../di/dependency_injector.dart';
import '../theme/app_theme.dart';

class AppRouter {
  //Define static routeNames here and then use in switch/navigator

  Route<dynamic> generateRoute(RouteSettings settings, String initialRoute) {
    switch (settings.name) {
      case '/':
        RouteSettings initialRouteSettings =
            RouteSettings(name: initialRoute, arguments: settings.arguments);
        return generateRoute(initialRouteSettings, initialRoute);
      case '/onboardingPage':
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case "/authenticationPage":
        return MaterialPageRoute(builder: (_) => const AuthenticationPage());
      case "/homePage":
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case "/publisherHomePage":
        return MaterialPageRoute(
          builder: (_) => const PublisherHomePage(),
        );
      case "/createUpdateArticlePage":
        return MaterialPageRoute(
          builder: (_) => const CreateUpdateArticlePage(),
          settings: settings,
        );
      case "/appColors":
        return MaterialPageRoute(
            builder: (_) => const MyHomePage(title: "AppColors"));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    debugPrint("myHomePage: init()");

    // sl<OnboardingDataSource>().getOnboardingData();
    // sl<OnboardingRepository>().getOnboardingData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sl<AppTheme>().lightTheme.colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(children: [
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.primary,
            ),
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.onPrimaryContainer,
            ),
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.onPrimaryFixed,
            ),
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.onPrimaryFixedVariant,
            ),
          ]),
          Row(children: [
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.onSurface,
            ),
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.onSurfaceVariant,
            ),
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.onInverseSurface,
            )
          ]),
          Row(children: [
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.tertiary,
            ),
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.tertiaryContainer,
            ),
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.tertiaryFixed,
            ),
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.tertiaryFixedDim,
            ),
          ]),
          Row(children: [
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.outline,
            ),
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.outlineVariant,
            ),
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.scrim,
            ),
          ]),
          Row(children: [

            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.surfaceBright,
            ),
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.surface,
            ),
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.surfaceContainer,
            ),
            Container(
              // alignment: ,
              margin: const EdgeInsets.all(10),
              height: 175,
              width: 175,
              color: colorScheme.surfaceTint,
            )
        ]),
        ]),
      ),
    );
  }
}
