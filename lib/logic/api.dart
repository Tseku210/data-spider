import 'dart:convert';
import 'dart:io';

import 'package:data_spider/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider with ChangeNotifier {
  String? userToken;
  ApiProvider() {
    getUserToken();
  }
  Future<void> getUserToken() async {
    SharedPreferences.getInstance().then((prefs) {
      userToken = prefs.getString('userToken');
    });
  }

  Future<bool> publish(Map<String, dynamic> data, String? frontImagePath,
      String? secondImagePath) async {
    await getUserToken();

    var url = Uri.parse('$apiGatewayUrl/cash-assist');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$userToken',
      },
      body: jsonEncode(data),
    );
    bool isPublishedToS3 = await publishPhotoToS3(
        frontImageId: data['frontImageId'],
        frontImagePath: frontImagePath!,
        backImageId: data['backImageId'],
        backImagePath: secondImagePath);

    if (response.statusCode == 200 && isPublishedToS3) {
      return true;
    }
    return false;
  }

  Future<bool> publishPhotoToS3({
    required String frontImageId,
    required String frontImagePath,
    String? backImageId,
    String? backImagePath,
  }) async {
    var frontImageFile = File(frontImagePath);
    var frontImageBytes = await frontImageFile.readAsBytes();
    var urlFront =
        Uri.parse('$apiGatewayUrl/blob?key=cash-assist/$frontImageId');
    var response = await http.put(
      urlFront,
      headers: {
        'Content-Type': 'image/png',
        'Authorization': '$userToken',
      },
      body: frontImageBytes,
    );

    if (backImageId != null && backImagePath != null) {
      var backImageFile = File(backImagePath);
      var backImageBytes = await backImageFile.readAsBytes();
      var urlBack =
          Uri.parse('$apiGatewayUrl/blob?key=cash-assist/$backImageId');
      await http.put(
        urlBack,
        headers: {
          'Content-Type': 'image/png',
          'Authorization': '$userToken',
        },
        body: backImageBytes,
      );
    }

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
