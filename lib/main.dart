import 'package:camera/camera.dart';
import 'package:data_spider/logic/api.dart';
import 'package:data_spider/logic/login.dart';
import 'package:data_spider/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'logic/camera_model.dart';

CameraDescription? camera;
CameraController? controller;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // camera setup
  final cameras = await availableCameras();
  if (cameras.isNotEmpty) {
    camera = cameras.first;
  } else {
    debugPrint("No cameras available");
  }
  //load env
  await dotenv.load();
  runApp(
    const MyApp(),
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

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext fcontext) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CameraModel(camera!)),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => ApiProvider()),
      ],
      child: MaterialApp.router(
        title: 'Data Spider',
        routerConfig: Routes.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
