import 'package:flutter/material.dart';

import '../utils/text_styles.dart';
import '../utils/theme.dart';

Future<void> showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.white,
        title: Text('Тайлбар ба заавар', style: TextStyles.textLargeBold()),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Бид харааны бэрхшээлтэй хүмүүст туслах зорилгоор мөнгөн тэмдэгт хиймэл оюун ухаан ашиглан утаснаасаа хялбар тоолох аппликейшн бүтээж буй тул өгөгдөл цуглуулалтанд оролцож буй таньд гүнээ талархаж байна.',
                  style: TextStyles.textMedium()),
              const Text(''),
              Text(
                  'Өгөгдөл цуглуулалтын явцад янз, янзын нөхцөл байдлыг тооцсоноор илүү сайн ажиллах тул та зургаа авахдаа дараах нөхцөл байдлыг боломжтой бол оруулж өгнө үү. Үүнд: мушгирсан, толбо болсон, давхардсан, ар өвөрийн зурагнууд, бүдэг гэрэл, тод гэрэл, байгалийн гэрэлд, нарны гэрлийн эгц доор, сүүдэртэйд, нойтон, хуучин, шинэ, ард талд нь ижил өнгийн тавилгууд, бага зэрэг урагдсан, скочоор наасан, сарны гэрэл дор гэх мэт.',
                  style: TextStyles.textMedium()),
              const Text(''),
              Text('Заавар:', style: TextStyles.textLargeBold()),
              Text(
                  'Эхний ээлжинд ар, өврийн мөнгөн дэвсгэртийн зураг болон дараагаар гартаа бариад тоолж буй зураг байвал их сайн. Нэг зурганд хэрэв нэгээс дээш, олон мөнгөн дэвсгэрт орсон үед мөнгөн тэмдэгт тус бүрт харгалзах ширхэгийг оруулах, нэг зурганд 3-аас илүүгүй мөнгөн дэвсгэрт багтаахгүй байх.',
                  style: TextStyles.textMedium()),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ойлголоо'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
