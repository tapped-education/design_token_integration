import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_text_theme.freezed.dart';

@freezed
class AppTextTheme with _$AppTextTheme {
  const factory AppTextTheme({
    required TextStyle caption,
    required TextStyle copy,
    required TextStyle extraHuge,
    required TextStyle label,
    required TextStyle subCopy,
    required TextStyle subtitle,
    required TextStyle title,
  }) = _AppTextTheme;
}
