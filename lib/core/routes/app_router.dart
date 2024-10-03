
import 'package:flutter/material.dart';
import 'package:interested/features/onboarding/data/datasources/onboarding_datasource.dart';

import '../di/dependency_injector.dart';
import '../theme/app_theme.dart';

class AppRouter {

  //Define static routeNames here and then use in switch/navigator

  Route<dynamic> generateRoute(RouteSettings settings) {


    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MyHomePage(title: "TestTitle"));
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

    sl<OnboardingDataSource>().getOnboardingData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // ColorScheme#3aa7c(primary: Color(0xff785900), primaryContainer: Color(0xffffdf9e), onPrimaryContainer: Color(0xff261a00), secondary: Color(0xff6b5d3f), onSecondary: Color(0xffffffff), secondaryContainer: Color(0xfff5e0bb), onSecondaryContainer: Color(0xff241a04), tertiary: Color(0xff4a6547), onTertiary: Color(0xffffffff), tertiaryContainer: Color(0xffccebc4), onTertiaryContainer: Color(0xff072109), error: Color(0xffba1a1a), errorContainer: Color(0xffffdad6), onErrorContainer: Color(0xff410002), background: Color(0xfffffbff), onBackground: Color(0xff1e1b16), surface: Color(0xfffffbff), onSurface: Color(0xff1e1b16), surfaceVariant: Color(0xffede1cf), onSurfaceVariant: Color(0xff4d4639), outline: Color(0xff7f7667), outlineVariant: Color(0xffd0c5b4), inverseSurface: Color(0xff33302a), onInverseSurface: Color(0xfff7efe7), inversePrimary: Color(0xfffabd00), surfaceTint: Color(0xff785900))

    var cs =  sl<AppTheme>().lightTheme.colorScheme.toString(minLevel: DiagnosticLevel.debug);
    debugPrint("build():cs: $cs");
    var res = cs.substring(18,cs.length);
    debugPrint("build():res: $res");
    var lines = res.split(',');
    debugPrint("build():lines: $lines");


    return Scaffold(
      appBar: AppBar(
        backgroundColor: sl<AppTheme>().lightTheme.colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: getAppColorsView(lines),

    );
  }

  getAppColorsView(List<String> lines) {

    List<Widget> appColorsContainer = [];

    for (var line in lines) {
      debugPrint("build():line: $line");


      var colorsName = line.split(':')[0];
      var colorCode = line.split(':')[1];
      debugPrint("build():colorName: $colorsName colorCode: $colorCode ");

      var colorCodeInt;
      if(line!=lines[0]) {
        colorCodeInt = colorCode.substring(7,17);
      }else {
        var colorCode1 = line.split(':')[2];
        colorCodeInt = colorCode1.substring(7,17);
    }

      appColorsContainer.add(
        Expanded(
          child: Container(
            // alignment: ,
            margin: const EdgeInsets.all(10),
            height: 200,
            width: 200,
            color: Color(

                int.parse(colorCodeInt)
            ),
            child: Center(child: Text(colorsName),),
          ),
        )
      );

    }

    return Column(
      children: [
        Row(
          children: [
            appColorsContainer[0],
            appColorsContainer[1],
            appColorsContainer[2],
            appColorsContainer[3],
            appColorsContainer[4],
          ],
        ),
        Row(
          children: [
            appColorsContainer[5],
            appColorsContainer[6],
            appColorsContainer[7],
            appColorsContainer[8],
            appColorsContainer[9],

          ],
        ),
        Row(
          children: [
            appColorsContainer[10],
            appColorsContainer[11],
            appColorsContainer[12],
            appColorsContainer[13],
            appColorsContainer[14],
            appColorsContainer[15],
          ],
        ),
      ],
    );

  }
}