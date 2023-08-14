import 'package:data_spider/widgets/moneyandquantity.dart';
import 'package:flutter/material.dart';

class MoneyData {
  TextEditingController moneyTypeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  Widget buildWidget() {
    return moneyAndQuantity(moneyTypeController, quantityController);
  }

  Map<String, dynamic> toJson() {
    return {
      'moneyType': moneyTypeController.text,
      'quantity': quantityController.text,
    };
  }

  void dispose() {
    moneyTypeController.dispose();
    quantityController.dispose();
  }
}
