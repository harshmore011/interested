
import 'package:flutter/material.dart' show ColorScheme, ThemeData, Color, Colors;

class AppTheme {

  // static final ColorScheme _colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepOrange);
  // static final ColorScheme _colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepOrange);
  static final ColorScheme _colorScheme = ColorScheme.fromSeed(seedColor: colorPrimary);
  static final ColorScheme _appColorScheme = _colorScheme.copyWith(primary: colorPrimary);
  // static const Color colorPrimary = Color(0xffe44304);
  // static const Color colorPrimary = Colors.deepOrange;
  // static const Color colorPrimary = Colors.orangeAccent;
  static const Color colorPrimary = Colors.amber;

  static final Color primaryColor = _colorScheme.primary;
  static final Color secondaryColor = _colorScheme.secondary;
  static final Color onPrimaryColor = _colorScheme.onPrimary;
  static final Color onSecondaryColor = _colorScheme.onSecondary;
  static final Color surfaceColor = _colorScheme.surface;
  static final Color onSurfaceColor = _colorScheme.onSurface;
  static final Color errorColor = _colorScheme.error;
  static final Color onErrorColor = _colorScheme.onError;

  final ThemeData lightTheme = ThemeData(
    // colorScheme: _colorScheme,
    colorScheme: _appColorScheme,
    useMaterial3: true,
  );

/*  static final ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(),
    useMaterial3: true,
  );*/

}
