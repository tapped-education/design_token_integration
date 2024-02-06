import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:styling/app_text_theme.dart';
import 'package:styling/dimension_data.dart';

part 'app_theme_data.freezed.dart';

@freezed
class AppThemeData with _$AppThemeData {
  const AppThemeData._();

  const factory AppThemeData({
    required Brightness brightness,
    required Color borderActive,
    required Color borderHeader,
    required Color borderInactive,
    required Color borderLicenseplate,
    required Color surfaceButtonPrimary,
    required Color surfaceCardOverlay,
    required Color surfaceUnderInput,
    required Color surfaceDefault,
    required Color surfaceHover,
    required Color surfaceLicenseplate,
    required Color surfaceTabActive,
    required Color surfaceTabInactive,
    required Color surfaceInput,
    required Color surfaceErrorSubtle,
    required Color surfaceSnackSuccess,
    required Color surfaceSnackInfo,
    required Color surfaceSnackError,
    required Color textActive,
    required Color textBodySecondary,
    required Color textStart,
    required Color textDestination,
    required Color textError,
    required Color textLicenseplate,
    required Color textLicenseplateInactive,
    required Color textOnCta,
    required Color textPrimary,
    required Color textShadow,
    required Color textWarning,
    required Color textSnackError,
    required Color textSnackSuccess,
    required Color textSnackInfo,
    required double listElementsRadius,
    required AppTextTheme textStyle,
    required DimensionData dimension,
  }) = _AppThemeData;

  Duration get animationDuration => const Duration(milliseconds: 250);

  Curve get animationCurve => Curves.easeInOut;

  double get defaultOpacity => 0.92;
}
