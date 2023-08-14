import 'package:flutter/material.dart';

import '../utils/text_styles.dart';
import '../utils/theme.dart';

Widget sendButton({VoidCallback? onSend}) {
  return SizedBox(
    width: double.infinity,
    height: 70,
    child: FilledButton(
      onPressed: onSend,
      style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => AppColors.blue),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(
            color: AppColors.black.withOpacity(0.1),
            width: 2,
          ),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
      child: Text(
        'Илгээх',
        style: TextStyles.textLargeBold().copyWith(color: AppColors.white),
      ),
    ),
  );
}
