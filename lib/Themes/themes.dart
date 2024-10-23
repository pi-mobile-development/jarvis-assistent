import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static Color get appBarColor => const Color(0xFF1A1A1A);
  static Color get primaryColor => const Color(0xFF333333);
  static Color get secondaryColor => const Color(0xff9489F5);
  
  static Color get textColor => Colors.white;

  static OutlineInputBorder get outlineInputBorder => OutlineInputBorder(
    borderSide: BorderSide(color: AppTheme.secondaryColor),
    borderRadius: BorderRadius.circular(12)
  );
}
