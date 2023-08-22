import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraModel with ChangeNotifier {
  CameraDescription? camera;
  CameraController? _controller;
  bool isInitialized = false;
  bool isCameraOn = false;

  CameraModel(CameraDescription this.camera) {
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      _controller = CameraController(
        camera!,
        ResolutionPreset.max,
      );
      // await controller.initialize();
      isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error occurred during camera initialization: $e');
      isInitialized = false;
    }
  }

  CameraController get controller {
    return _controller!;
  }

  void toggle() {
    isCameraOn = !isCameraOn;
    // notifyListeners();
  }

  Future<String?> takeImage() async {
    try {
      if (_controller == null) {
        print("Camera is not initialized.");
        return null;
      }

      if (!_controller!.value.isInitialized ||
          !_controller!.value.isTakingPicture) {
        _controller!.setFlashMode(FlashMode.off);
        await _controller!.setFocusMode(FocusMode.locked);
        await _controller!.setExposureMode(ExposureMode.locked);
        XFile picture = await _controller!.takePicture();
        await _controller!.setFocusMode(FocusMode.locked);
        await _controller!.setExposureMode(ExposureMode.locked);
        print("Picture saved: ${picture.path}");
        return picture.path; // Return the path
      } else {
        print("Camera is busy. Couldn't capture image.");
        return null;
      }
    } catch (e) {
      print("Error taking picture: $e");
      return null;
    } finally {
      print("Finally block executed");
      toggle();
    }
  }

  @override
  void dispose() {
    print("disposing camera controller");
    _controller!.dispose();
    isInitialized = false;
    super.dispose();
  }
}
