import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/camera_model.dart';
import '../utils/theme.dart';

class Camera extends StatefulWidget {
  final VoidCallback onImageTaken;
  const Camera({super.key, required this.onImageTaken});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    CameraModel cameraProvider = context.read<CameraModel>();
    return Stack(
      children: [
        CameraPreview(cameraProvider.controller),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(
              onPressed: widget.onImageTaken,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(
                Icons.camera,
                size: 100,
                color: AppColors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
