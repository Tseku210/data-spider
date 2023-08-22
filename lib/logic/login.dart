import 'package:data_spider/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../cognito_login_webview.dart';

class LoginProvider extends ChangeNotifier {
  final Uuid uuid = const Uuid();
  late String userId;
  late String username;
  bool _isLoggedIn = false;

  LoginProvider();

  void initiateSignIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CognitoLoginWebView(
          onTokenReceived: (token) async {
            await saveToken(token);
            await extractUserInfo();
            isLoggedIn = true;
            notifyListeners();
          },
        ),
      ),
    );
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', token);
  }

  Future<void> extractUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    // print('decodedToken: ${decodedToken.toString()}');
    // userId = decodedToken['sub'];
    userId = uuid.v4();
    username = decodedToken['cognito:username'];
  }

  Future<void> signInUser(String username, String password) async {
    try {
      var url = Uri.parse('$cognitoDomain/oauth2/token');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'implicit',
          'client_id': cognitoClientId,
          'username': username,
          'password': password,
        },
      );

      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
}
