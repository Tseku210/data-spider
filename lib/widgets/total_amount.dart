import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/text_styles.dart';
import '../utils/theme.dart';

Widget totalAmount(String text, {required Function(String) onChanged}) {
  return Column(
    children: [
      Row(
        children: [
          Text(text, style: TextStyles.textLargeBold()),
          Text("*",
              style: TextStyles.textLargeBold().copyWith(color: AppColors.red)),
        ],
      ),
      const SizedBox(height: 8),
      TextField(
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset('assets/icons/tugrik.svg',
                color: AppColors.grey),
          ),
          hintText: '25000',
          hintStyle: TextStyles.textLargeBold().copyWith(color: AppColors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: AppColors.black.withOpacity(0.1), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: AppColors.black.withOpacity(0.1), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.blue, width: 2),
          ),
        ),
        style: TextStyles.textLargeBold(),
      ),
      const SizedBox(height: 20),
    ],
  );
}
