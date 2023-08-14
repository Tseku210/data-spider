import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:camera/camera.dart';
import 'package:camera_platform_interface/src/types/camera_description.dart';
import 'package:data_spider/logic/money_data.dart';
import 'package:data_spider/utils/text_styles.dart';
import 'package:data_spider/utils/theme.dart';
import 'package:data_spider/widgets/camera_preview.dart';
import 'package:data_spider/widgets/dialog.dart';
import 'package:data_spider/widgets/moneyandquantity.dart';
import 'package:data_spider/widgets/moneytypeandquantity.dart';
import 'package:data_spider/widgets/sendbutton.dart';
import 'package:data_spider/widgets/total_amount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'logic/camera_model.dart';
import 'logic/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // providers
  late HomeScreenProvider _homeProvider;
  late CameraModel _cameraProvider;

  var uuid = const Uuid();

  List<MoneyData> moneyWidgets = [];

  String? frontImagePath;
  String? backImagePath;

  String frontImageTitle = "Нүүр хэсгийн зураг";
  String backImageTitle = "Арын зураг";

  bool isLoadingFrontImage = false;
  bool isLoadingBackImage = false;

  TextEditingController totalAmountController = TextEditingController();

  Map<String, dynamic> data = {
    'userId': '',
    'username': '',
    'frontImageId': '',
    'backImageId': '',
    'totalAmount': '',
    'imageDesc': [],
  };

  void populateData() async {
    AuthUser user = context.read<HomeScreenProvider>().user;
    data['userId'] = user.userId;
    data['username'] = user.username;
    data['frontImageId'] = uuid.v4();
    data['backImageId'] = uuid.v4();
    data['totalAmount'] = totalAmountController.text;
    data['imageDesc'] = extractImageDesc();

    validateData();
  }

  List<Map<String, dynamic>> extractImageDesc() {
    List<Map<String, dynamic>> imageDesc = [];
    for (var moneyWidget in moneyWidgets) {
      imageDesc.add(moneyWidget.toJson());
    }
    return imageDesc;
  }

  void sendData() async {
    populateData();
    bool isPublished = await _homeProvider.publish(data);
    if (isPublished) {
      alertWidget('Амжилттай илгээлээ', 'Таньд баярлалаа');
      reset();
    } else {
      alertWidget('Амжилттай илгээлээ', 'Таньд баярлалаа');
    }
  }

  @override
  void initState() {
    super.initState();

    moneyWidgets.add(MoneyData());
  }

  @override
  void dispose() {
    super.dispose();

    for (var moneyData in moneyWidgets) {
      moneyData.dispose();
    }
  }

  void reset() {
    setState(() {
      frontImagePath = null;
      backImagePath = null;
      totalAmountController.text = '';
      moneyWidgets = [];
      moneyWidgets.add(MoneyData());
    });
  }

  void validateData() {
    if (data['userId'].isEmpty ||
        data['username'].isEmpty ||
        data['frontImageId'].isEmpty ||
        data['totalAmount'].isEmpty ||
        data['imageDesc'].isEmpty) {
      // If any of the above fields are empty, show an alert
      print('========>' + data['totalAmount']);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Дутуу бөглөсөн'),
            content: Text('* тэмдэглэгээтэй талбаруудыг заавал бөглөнө үү'),
            actions: [
              TextButton(
                child: Text('Ойлголоо'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // All required fields are filled
      // Proceed with your logic, for instance, save the data or send it to a server.
    }
  }

  Widget alertWidget(text, content) {
    return AlertDialog(
      title: Text(text),
      content: Text(content),
      actions: [
        TextButton(
          child: Text('Ойлголоо'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _addMoneyWidget() async {
    MoneyData moneyData = MoneyData();
    setState(() {
      moneyWidgets.add(moneyData);
    });

    await _homeProvider.postData();
  }

  void _removeMoneyWidget() {
    if (moneyWidgets.length > 1) {
      MoneyData moneyData = moneyWidgets.removeLast();
      moneyData.dispose();
      setState(() {});
    }
  }

  void onImageTaken() async {
    if (frontImagePath == null) {
      setState(() {
        isLoadingFrontImage = true;
      });
    } else {
      setState(() {
        isLoadingBackImage = true;
      });
    }

    _cameraProvider.toggle();
    await _cameraProvider.takePicture((imagePath) {
      safePrint('imagePath ==================: $imagePath');
      if (frontImagePath != null) {
        setState(() {
          backImagePath = imagePath;
          isLoadingBackImage = false;
        });
        return;
      }
      setState(() {
        frontImagePath = imagePath;
        isLoadingFrontImage = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _homeProvider = context.watch<HomeScreenProvider>();
    _cameraProvider = context.watch<CameraModel>();
    return Scaffold(
      body: _cameraProvider.isCameraOn
          ? FutureBuilder<void>(
              future: _cameraProvider.initializeControllerFuture,
              builder: (context, snapshot) {
                if (!_cameraProvider.isInitialized) {
                  // This means the _initializeControllerFuture hasn't been properly initialized yet
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
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
                        frontImageTitle,
                        onCamera: () {
                          _cameraProvider.toggle();
                          setState(() {
                            frontImagePath = null;
                          });
                        },
                      ),
                      cameraWidget(
                        backImageTitle,
                        isMandatory: false,
                        onCamera: () {
                          _cameraProvider.toggle();
                          setState(() {
                            backImagePath = null;
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

  Widget cameraWidget(String text,
      {bool isMandatory = true, VoidCallback? onCamera}) {
    String? imagePath;
    if (text == frontImageTitle) {
      imagePath = frontImagePath;
    } else {
      imagePath = backImagePath;
    }

    safePrint('imagePath inside cameraWidget ==================: $imagePath');

    return GestureDetector(
      onTap: onCamera,
      child: Column(
        children: [
          Row(
            children: [
              Text(text, style: TextStyles.textLargeBold()),
              isMandatory
                  ? Text("*",
                      style: TextStyles.textLargeBold()
                          .copyWith(color: AppColors.red))
                  : Container(),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: imagePath == null ? 200 : 500,
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.03),
            ),
            child: text == frontImageTitle && isLoadingFrontImage
                ? const Center(child: CircularProgressIndicator())
                : text == backImageTitle && isLoadingBackImage
                    ? const Center(child: CircularProgressIndicator())
                    : imagePath == null
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
                        : Image.file(File(imagePath), fit: BoxFit.contain),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
