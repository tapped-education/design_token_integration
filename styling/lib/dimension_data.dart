import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dimension_data.freezed.dart';

@freezed
class DimensionData with _$DimensionData {
  const DimensionData._();

  const factory DimensionData({
    required double xxs,
    required double xs,
    required double s,
    required double sm,
    required double m,
    required double l,
    required double xl,
    required double xxl,
    required double xxxl,
  }) = _DimensionData;

  double get horizontalSpace => l;

  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: horizontalSpace);

  double get verticalSpace => l;

  EdgeInsets get verticalPadding =>
      EdgeInsets.symmetric(vertical: verticalSpace);
}
