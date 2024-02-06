import 'package:flutter/material.dart' hide Size;
import 'package:styling/app_theme_data.dart';

class AppTheme extends InheritedWidget {
  final Brightness _brightness;

  final AppThemeData _lightTheme;
  final AppThemeData _darkTheme;

  const AppTheme({
    required Brightness brightness,
    required AppThemeData lightTheme,
    required AppThemeData darkTheme,
    required super.child,
    super.key,
  })  : _brightness = brightness,
        _lightTheme = lightTheme,
        _darkTheme = darkTheme;

  static AppThemeData of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppTheme>()!;
    return result._brightness == Brightness.light
        ? result._lightTheme
        : result._darkTheme;
  }

  @override
  bool updateShouldNotify(covariant AppTheme oldWidget) {
    return _brightness != oldWidget._brightness;
  }
}
