import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';

class HomeScreenProvider extends ChangeNotifier {
  late AuthUser user;

  Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    return result.isSignedIn;
  }

  HomeScreenProvider() {
    fetchUser();
  }

  Future<void> fetchUser() async {
    user = await Amplify.Auth.getCurrentUser();
  }

  Future<JsonWebToken?> fetchToken() async {
    try {
      final cognitoPlugin =
          Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
      final result = await cognitoPlugin.fetchAuthSession();
      final token = result.userPoolTokensResult.value.accessToken;
      safePrint("Current user's token: $token");
      return token;
    } on AuthException catch (e) {
      safePrint('Error retrieving auth session: ${e.message}');
    }
    return null;
  }

  Future<bool> publish(Map<String, dynamic> data) async {
    try {
      final restOperation = Amplify.API.post(
        'cash-assist',
        body: HttpPayload.json(data),
      );
      final response = await restOperation.response;
      safePrint('POST call succeeded: ${response.decodeBody()}');
      return true;
    } catch (e) {
      safePrint('POST call failed: $e');
      return false;
    }
  }

  Future<void> postTodo() async {
    try {
      final restOperation = Amplify.API.post(
        'todo',
        body: HttpPayload.json({'name': 'Mow the lawn'}),
      );
      final response = await restOperation.response;
      print('POST call succeeded');
      print(response.decodeBody());
    } on ApiException catch (e) {
      print('POST call failed: $e');
    }
  }

  Future<void> getData() async {
    try {
      final restOperation = Amplify.API.get('/');
      final response = await restOperation.response;
      safePrint('GET call succeeded: ${response.decodeBody()}');
    } catch (e) {
      safePrint('GET call failed: $e');
    }
  }

  Future<void> postData() async {
    try {
      final restOperation = Amplify.API.post(
        'cash-assist',
        body: HttpPayload.json({'name': 'Mow the lawn'}),
      );
      final response = await restOperation.response;
      safePrint('POST call succeeded: ${response.decodeBody()}');
    } catch (e) {
      safePrint('POST call failed: $e');
    }
  }
}
