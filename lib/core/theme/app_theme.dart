import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_brand_colors.dart';

extension BuildContextThemeExtension on BuildContext {
  AppBrandColors get brand =>
      Theme.of(this).extension<AppBrandColors>() ?? AppBrandColors.dark;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

class AppStyles {
  AppStyles._();

  static TextStyle get displayLarge => TextStyle(
    fontSize: 32.spMin,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    fontFamily: 'Roboto',
  );

  static TextStyle get titleLarge => TextStyle(
    fontSize: 22.spMin,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    fontFamily: 'Roboto',
  );

  static TextStyle get titleMedium => TextStyle(
    fontSize: 18.spMin,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    fontFamily: 'Roboto',
  );

  static TextStyle get bodyLarge => TextStyle(
    fontSize: 16.spMin,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    fontFamily: 'Roboto',
  );

  static TextStyle get bodyMedium => TextStyle(
    fontSize: 14.spMin,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    fontFamily: 'Roboto',
  );

  static TextStyle get caption => TextStyle(
    fontSize: 12.spMin,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.8,
    fontFamily: 'Roboto',
  );

  static TextStyle get hudMono => TextStyle(
    fontSize: 11.spMin,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.6,
    fontFamily: 'Courier',
  );
}
