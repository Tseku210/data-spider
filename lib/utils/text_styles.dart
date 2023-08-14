import 'dart:ui';

import 'package:data_spider/utils/theme.dart';
import 'package:flutter/cupertino.dart';

class FontSize {
  FontSize._();
  // 57
  static const double displayLarge = 57;
  // 45
  static const double displayMedium = 45;
  //36
  static const double displaySmall = 36;
  // 32
  static const double headlineLarge = 32;
  // 28
  static const double headlineMedium = 28;
  // 24
  static const double headlineSmall = 24;
  // 22
  static const double titleXLarge = 22;
  // 20
  static const double titleLarge = 20;
  // 18
  static const double titleLarge3 = 18;
  // 16
  static const double titleMedium = 16;
  // 14
  static const double titleSmall = 14;
  // 12
  static const double titleXSmall = 12;
  // 14
  static const double labelLarge = 14;
  // 12
  static const double labelMedium = 12;
  // 11
  static const double labelSmall = 11;
  // 18
  static const double bodyXLarge = 18;
  // 16
  static const double bodyLarge = 18;
  // 14
  static const double bodyMedium = 14;
  // 12
  static const double bodySmall = 12;
  // 18
  static const double phoneInput = 18;
  static const double text14 = 14;
  static const double text16 = 16;
  static const double text18 = 18;
  static const double button = 18;
}

class TextStyles {
  TextStyles._();

  static TextStyle textLargeBold() => const TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w700,
        color: AppColors.black,
        fontSize: FontSize.bodyLarge,
        height: 1.2,
      );

  static TextStyle textMedium() => const TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w400,
        color: AppColors.black,
        fontSize: FontSize.bodyMedium,
        height: 1.2,
      );
}
