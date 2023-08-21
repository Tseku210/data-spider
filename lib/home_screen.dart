import 'dart:io';

import 'package:camera/camera.dart';
import 'package:data_spider/logic/api.dart';
import 'package:data_spider/logic/login.dart';
import 'package:data_spider/logic/money_data.dart';
import 'package:data_spider/models/camera_data.dart';
import 'package:data_spider/utils/text_styles.dart';
import 'package:data_spider/utils/theme.dart';
import 'package:data_spider/widgets/camera_preview.dart';
import 'package:data_spider/widgets/dialog.dart';
import 'package:data_spider/widgets/moneytypeandquantity.dart';
import 'package:data_spider/widgets/sendbutton.dart';
import 'package:data_spider/widgets/total_amount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'logic/camera_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // providers
  // late CameraModel _cameraProvider;
  // late LoginProvider _loginProvider;

  var uuid = const Uuid();

  List<MoneyData> moneyWidgets = [];

  CameraData frontCamera = CameraData(text: 'Нүүр хэсгийн зураг');
  CameraData backCamera = CameraData(text: 'Арын зураг', isMandatory: false);

  TextEditingController totalAmountController = TextEditingController();

  Map<String, dynamic> data = {
    'userId': '',
    'username': '',
    'frontImageId': '',
    'backImageId': '',
    'totalAmount': '',
    'imageDesc': [],
  };

  bool populateData() {
    LoginProvider loginProvider = context.read<LoginProvider>();
    data['userId'] = loginProvider.userId;
    data['username'] = loginProvider.username;
    data['frontImageId'] = uuid.v4();
    data['backImageId'] = uuid.v4();
    data['totalAmount'] = totalAmountController.text;
    data['imageDesc'] = extractImageDesc();

    bool isOk = validateData();
    return isOk ? true : false;
  }

  List<Map<String, dynamic>> extractImageDesc() {
    List<Map<String, dynamic>> imageDesc = [];
    for (var moneyWidget in moneyWidgets) {
      imageDesc.add(moneyWidget.toJson());
    }
    return imageDesc;
  }

  Future<void> sendData() async {
    print("About to populate data...");
    bool isOk = populateData();
    print("Data populated: $isOk");

    if (!isOk) {
      return;
    }
    bool isPublished = await context
        .read<ApiProvider>()
        .publish(data, frontCamera.getImagePath, backCamera.getImagePath);
    if (isPublished) {
      alertWidget('Амжилттай илгээлээ', 'Таньд баярлалаа');
      reset();
      return;
    } else {
      alertWidget('Ямар нэг алдаа гарлаа', 'Та дахин оруулаад илгээнэ үү');
    }
  }

  @override
  void initState() {
    super.initState();
    moneyWidgets.add(MoneyData());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController =
        context.read<CameraModel>().controller;

    // App state changed before we got the chance to initialize.
    if (!cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
      context.read<CameraModel>().dispose();
    } else if (state == AppLifecycleState.resumed) {
      context.read<CameraModel>().initCamera();
    }
  }

  @override
  void dispose() {
    super.dispose();

    totalAmountController.dispose();
    Provider.of<CameraModel>(context).dispose();

    for (var moneyData in moneyWidgets) {
      moneyData.dispose();
    }
  }

  void reset() {
    setState(() {
      frontCamera.reset();
      backCamera.reset();
      totalAmountController.text = '';
      moneyWidgets = [];
      moneyWidgets.add(MoneyData());
    });
  }

  bool validateData() {
    if (data['userId'].isEmpty ||
        data['username'].isEmpty ||
        data['frontImageId'].isEmpty ||
        data['totalAmount'].isEmpty ||
        data['imageDesc'].isEmpty ||
        frontCamera.getImagePath == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Дутуу бөглөсөн'),
            content:
                const Text('* тэмдэглэгээтэй талбаруудыг заавал бөглөнө үү'),
            actions: [
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
      return false;
    } else {
      return true;
      // All required fields are filled
      // Proceed with your logic, for instance, save the data or send it to a server.
    }
  }

  Future alertWidget(text, content) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(text),
            content: Text(content),
            actions: [
              TextButton(
                child: const Text('Ойлголоо'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _addMoneyWidget() async {
    MoneyData moneyData = MoneyData();
    setState(() {
      moneyWidgets.add(moneyData);
    });
  }

  void _removeMoneyWidget() {
    if (moneyWidgets.length > 1) {
      MoneyData moneyData = moneyWidgets.removeLast();
      moneyData.dispose();
      setState(() {});
    }
  }

  Future<void> onImageTaken() async {
    print("onImageTaken");
    // if (frontCamera.imagePath == null) {
    //   setState(() {
    //     frontCamera.setIsLoading = true;
    //   });
    // } else {
    //   setState(() {
    //     backCamera.setIsLoading = true;
    //   });
    // }

    CameraModel cameraProvider = context.read<CameraModel>();
    String? imagePath = await cameraProvider.takeImage();
    if (imagePath != null) {
      if (frontCamera.imagePath != null) {
        setState(() {
          backCamera.setImagePath = imagePath;
          backCamera.setIsLoading = false;
        });
      } else {
        setState(() {
          frontCamera.setImagePath = imagePath;
          frontCamera.setIsLoading = false;
        });
      }
    }
  }

  void deleteImage(String? path) async {
    if (path == null) return;
    File file = File(path);
    if (await file.exists()) {
      print("deleting file");
      await file.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    CameraModel _cameraProvider = context.watch<CameraModel>();
    // _loginProvider = context.watch<LoginProvider>();
    Future<void> initializeControllerFuture =
        _cameraProvider.controller.initialize();
    return Scaffold(
      body: _cameraProvider.isCameraOn
          ? FutureBuilder<void>(
              future: initializeControllerFuture,
              builder: (context, snapshot) {
                if (!_cameraProvider.isInitialized) {
                  // This means the _initializeControllerFuture hasn't been properly initialized yet
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  print("camera on");
                  return Camera(onImageTaken: onImageTaken);
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FilledButton(
                            onPressed: () {
                              showMyDialog(context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => AppColors.red),
                              side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(
                                  color: AppColors.black.withOpacity(0.1),
                                  width: 2,
                                ),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            child: Text(
                              'Тайлбар харах',
                              style: TextStyles.textLargeBold()
                                  .copyWith(color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      cameraWidget(
                        frontCamera,
                        onCamera: () {
                          _cameraProvider.toggle();
                          deleteImage(frontCamera.getImagePath);
                          setState(() {
                            frontCamera.setImagePath = null;
                          });
                        },
                      ),
                      cameraWidget(
                        backCamera,
                        onCamera: () {
                          _cameraProvider.toggle();
                          deleteImage(backCamera.getImagePath);
                          setState(() {
                            backCamera.setImagePath = null;
                          });
                        },
                      ),
                      totalAmount("Нийт мөнгөн дүн", onChanged: (value) {
                        totalAmountController.text = value;
                      }),
                      moneyTypeAndQuantityWidget(
                        "Дэвсгэртийн тоо",
                        onClick: _addMoneyWidget,
                        onRemove: _removeMoneyWidget,
                        moneyWidgets: moneyWidgets
                            .map((moneyData) => moneyData.buildWidget())
                            .toList(),
                      ),
                      sendButton(onSend: sendData),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget cameraWidget(CameraData cameraData, {VoidCallback? onCamera}) {
    return GestureDetector(
      onTap: onCamera,
      child: Column(
        children: [
          Row(
            children: [
              Text(cameraData.getText, style: TextStyles.textLargeBold()),
              cameraData.isMandatory
                  ? Text("*",
                      style: TextStyles.textLargeBold()
                          .copyWith(color: AppColors.red))
                  : Container(),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: cameraData.getImagePath == null ? 200 : 500,
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.03),
            ),
            child: cameraData.isLoading
                ? const Center(child: CircularProgressIndicator())
                : cameraData.getImagePath == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/camera.svg'),
                            Text(
                              'Энэд дарж зураг оруулна уу',
                              style: TextStyles.textMedium()
                                  .copyWith(color: AppColors.greyText),
                            ),
                          ],
                        ),
                      )
                    : Image.file(File(cameraData.getImagePath!),
                        fit: BoxFit.contain),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
