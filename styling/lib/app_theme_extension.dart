import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:styling/app_theme_data.dart';
import 'package:universal_platform/universal_platform.dart';

extension AppThemeDataExtension on AppThemeData {
  ThemeData toTheme() {
    return switch (brightness) {
      Brightness.light => toLightTheme(),
      Brightness.dark => toDarkTheme(),
    };
  }
}

extension on AppThemeData {
  ThemeData toLightTheme() {
    assert(brightness == Brightness.light);
    final theme = ThemeData.light();
    final appTheme = this;

    return theme.copyWith(
      primaryColor: appTheme.surfaceButtonPrimary,
      hoverColor:
          appTheme.surfaceButtonPrimary.darken(amount: 0.1).withOpacity(0.1),
      highlightColor:
          appTheme.surfaceButtonPrimary.darken(amount: 0.1).withOpacity(0.1),
      splashColor:
          appTheme.surfaceButtonPrimary.darken(amount: 0.4).withOpacity(0.1),
      textSelectionTheme: theme.textSelectionTheme.copyWith(
        cursorColor: appTheme.surfaceButtonPrimary,
        selectionHandleColor: appTheme.surfaceButtonPrimary.withOpacity(0.4),
        selectionColor: appTheme.surfaceButtonPrimary.withOpacity(0.4),
      ),
      dialogBackgroundColor: appTheme.surfaceInput,
      colorScheme: theme.colorScheme.copyWith(
        errorContainer: appTheme.textError,
        // will be used for the android overscroll glow effect
        secondary: appTheme.surfaceButtonPrimary,
      ),
      // To fix the selection handler color on iOS
      cupertinoOverrideTheme:
          CupertinoThemeData(primaryColor: appTheme.surfaceButtonPrimary),
      checkboxTheme: theme.checkboxTheme.copyWith(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return appTheme.surfaceButtonPrimary;
          }
          return null;
        }),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        fillColor: appTheme.surfaceInput,
        filled: true,
        focusColor: appTheme.surfaceInput.darken(amount: 0.03),
        hoverColor: appTheme.surfaceInput.darken(amount: 0.03),
      ),
      dividerTheme: theme.dividerTheme.copyWith(
        color: appTheme.borderInactive,
        thickness: UniversalPlatform.isWeb ? 1.5 : 1,
        space: 1,
        indent: appTheme.dimension.l,
        endIndent: appTheme.dimension.l,
      ),
      dividerColor: appTheme.borderInactive,
      iconTheme: theme.iconTheme.copyWith(
        color: appTheme.textPrimary,
        size: 22.0,
      ),
      scaffoldBackgroundColor: appTheme.surfaceDefault,
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: appTheme.surfaceDefault,
        titleTextStyle: appTheme.textStyle.title,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          // to remove the gray background color of each android device
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: appTheme.surfaceDefault,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
    );
  }

  ThemeData toDarkTheme() {
    assert(brightness == Brightness.dark);
    final theme = ThemeData.dark();
    final appTheme = this;

    return theme.copyWith(
      primaryColor: appTheme.surfaceButtonPrimary,
      hoverColor:
          appTheme.surfaceButtonPrimary.darken(amount: 0.1).withOpacity(0.1),
      highlightColor:
          appTheme.surfaceButtonPrimary.darken(amount: 0.1).withOpacity(0.1),
      splashColor:
          appTheme.surfaceButtonPrimary.darken(amount: 0.4).withOpacity(0.1),
      textSelectionTheme: theme.textSelectionTheme.copyWith(
        cursorColor: appTheme.surfaceButtonPrimary,
        selectionHandleColor: appTheme.surfaceButtonPrimary.withOpacity(0.4),
        selectionColor: appTheme.surfaceButtonPrimary.withOpacity(0.4),
      ),
      dialogBackgroundColor: appTheme.surfaceInput,
      colorScheme: theme.colorScheme.copyWith(
        errorContainer: appTheme.textError,
        // will be used for the android overscroll glow effect
        secondary: appTheme.surfaceButtonPrimary,
      ),
      // To fix the selection handler color on iOS
      cupertinoOverrideTheme:
          CupertinoThemeData(primaryColor: appTheme.surfaceButtonPrimary),
      checkboxTheme: theme.checkboxTheme.copyWith(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return appTheme.surfaceButtonPrimary;
          }
          return null;
        }),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        fillColor: appTheme.surfaceInput,
        filled: true,
        focusColor: appTheme.surfaceInput.darken(amount: 0.03),
        hoverColor: appTheme.surfaceInput.darken(amount: 0.03),
      ),
      dividerTheme: theme.dividerTheme.copyWith(
        color: appTheme.borderInactive,
        thickness: UniversalPlatform.isWeb ? 1.5 : 1,
        space: 1,
        indent: appTheme.dimension.l,
        endIndent: appTheme.dimension.l,
      ),
      dividerColor: appTheme.borderInactive,
      iconTheme: theme.iconTheme.copyWith(
        color: appTheme.textPrimary,
        size: 22.0,
      ),
      scaffoldBackgroundColor: appTheme.surfaceDefault,
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: appTheme.surfaceDefault,
        titleTextStyle: appTheme.textStyle.title,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          // to remove the gray background color of each android device
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: appTheme.surfaceDefault,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
    );
  }
}

// From: https://stackoverflow.com/questions/58360989/programmatically-lighten-or-darken-a-hex-color-in-dart
extension ColorExtension on Color {
  Color darken({required double amount}) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
