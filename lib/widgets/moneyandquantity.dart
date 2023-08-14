import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/text_styles.dart';
import '../utils/theme.dart';

Widget moneyAndQuantity(TextEditingController moneyTypeController,
    TextEditingController quantityController) {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            flex: 8,
            child: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: AppColors.black.withOpacity(0.1), width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColors.blue, width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: AppColors.black.withOpacity(0.1), width: 2)),
                ),
                borderRadius: BorderRadius.circular(10),
                hint: Text(cashTypeList.first,
                    style: TextStyles.textMedium()
                        .copyWith(color: AppColors.greyText)),
                icon: const Icon(Icons.arrow_drop_down_rounded),
                items:
                    cashTypeList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyles.textLargeBold()),
                  );
                }).toList(),
                onChanged: (String? value) {
                  moneyTypeController.text = value ?? '';
                }),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixText: 'ш',
                hintText: '2',
                hintStyle:
                    TextStyles.textLargeBold().copyWith(color: AppColors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: AppColors.black.withOpacity(0.1), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: AppColors.black.withOpacity(0.1), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.blue, width: 2),
                ),
              ),
              style: TextStyles.textLargeBold(),
              onChanged: (value) {
                quantityController.text = value;
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
    ],
  );
}
