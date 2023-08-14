import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraModel with ChangeNotifier {
  CameraDescription? camera;
  late CameraController _controller;
  Future<void>? initializeControllerFuture;
  bool isInitialized = false;
  bool isCameraOn = false;

  CameraModel() {
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    camera = cameras.first;

    _controller = CameraController(
      camera!,
      ResolutionPreset.max,
    );
    initializeControllerFuture = _controller.initialize();
    isInitialized = true;
    // Notify listeners after initialization.
    notifyListeners();
  }

  void toggle() {
    isCameraOn = !isCameraOn;
    notifyListeners();
  }

  Future takePicture(Function(String) setImagePath) async {
    if (!_controller.value.isInitialized) {
      return null;
    }
    if (_controller.value.isTakingPicture) {
      return null;
    }
    try {
      await _controller.setFlashMode(FlashMode.off);
      XFile picture = await _controller.takePicture();
      setImagePath(picture.path);
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  CameraController get controller => _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
