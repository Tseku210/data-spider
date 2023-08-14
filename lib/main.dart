import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:camera/camera.dart';
import 'package:data_spider/home_screen.dart';
import 'package:data_spider/logic/provider.dart';
import 'package:data_spider/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'amplifyconfiguration.dart';
import 'logic/camera_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (context) => CameraModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final _router = GoRouter(routes: [
    GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(
            key: ValueKey('homeScreenKey'),
            child: HomeScreen(),
          );
        })
  ]);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      final api = AmplifyAPI();
      final storage = AmplifyStorageS3();
      await Amplify.addPlugins([api, auth, storage]);
      if (!Amplify.isConfigured) {
        await Amplify.configure(amplifyconfig);
      }
      print("Amplify configured successfully");
    } catch (e) {
      print("Failed to configure Amplify: $e");
      print("----> " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp.router(
        builder: Authenticator.builder(),
        routerConfig: MyApp._router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
