import 'package:flutter/material.dart';

import '../utils/text_styles.dart';
import '../utils/theme.dart';

Widget moneyTypeAndQuantityWidget(String text,
    {VoidCallback? onClick,
    VoidCallback? onRemove,
    List<Widget>? moneyWidgets}) {
  return Column(children: [
    Row(
      children: [
        Text(text, style: TextStyles.textLargeBold()),
        Text("*",
            style: TextStyles.textLargeBold().copyWith(color: AppColors.red)),
      ],
    ),
    const SizedBox(height: 8),
    Column(
      children: moneyWidgets!,
    ),
    const SizedBox(height: 8),
    SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onRemove ?? () {},
        style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => AppColors.grey),
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(
              color: AppColors.black.withOpacity(0.1),
              width: 2,
            ),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: Text(
          'Устгах',
          style: TextStyles.textLargeBold().copyWith(color: AppColors.white),
        ),
      ),
    ),
    const SizedBox(height: 8),
    SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onClick ?? () {},
        style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => AppColors.darkBlue),
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(
              color: AppColors.black.withOpacity(0.1),
              width: 2,
            ),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: Text(
          'Нэмэх',
          style: TextStyles.textLargeBold().copyWith(color: AppColors.white),
        ),
      ),
    ),
    const SizedBox(height: 50),
  ]);
}
