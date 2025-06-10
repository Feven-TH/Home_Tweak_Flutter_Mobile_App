import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String _fontFamily = 'Inter';

  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle header = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle bigHeader = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle label = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  //Added this missing styles
  static const TextStyle headline1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline5 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
}