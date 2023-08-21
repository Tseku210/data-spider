// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:flutter/cupertino.dart';

// class HomeScreenProvider extends ChangeNotifier {
//   Future<bool> publish(Map<String, dynamic> data) async {
//     try {
//       final restOperation = Amplify.API.post(
//         'cash-assist',
//         body: HttpPayload.json(data),
//       );
//       final response = await restOperation.response;
//       safePrint('POST call succeeded: ${response.decodeBody()}');
//       return true;
//     } catch (e) {
//       safePrint('POST call failed: $e');
//       return false;
//     }
//   }

//   Future<void> postTodo() async {
//     try {
//       final restOperation = Amplify.API.post(
//         'todo',
//         body: HttpPayload.json({'name': 'Mow the lawn'}),
//       );
//       final response = await restOperation.response;
//       print('POST call succeeded');
//       print(response.decodeBody());
//     } on ApiException catch (e) {
//       print('POST call failed: $e');
//     }
//   }

//   Future<void> getData() async {
//     try {
//       final restOperation = Amplify.API.get('/');
//       final response = await restOperation.response;
//       safePrint('GET call succeeded: ${response.decodeBody()}');
//     } catch (e) {
//       safePrint('GET call failed: $e');
//     }
//   }

//   Future<void> postData() async {
//     try {
//       final restOperation = Amplify.API.post(
//         'cash-assist',
//         body: HttpPayload.json({'name': 'Mow the lawn'}),
//       );
//       final response = await restOperation.response;
//       safePrint('POST call succeeded: ${response.decodeBody()}');
//     } catch (e) {
//       safePrint('POST call failed: $e');
//     }
//   }
// }
