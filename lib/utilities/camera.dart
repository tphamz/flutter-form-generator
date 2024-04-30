// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

List<CameraDescription> _cameras = <CameraDescription>[];
double MIN_AVAILBLE_ZOOM = 1.0;
double MAX_AVAILBLE_ZOOM = 1.0;

Future<void> cameraInit() async {
  if (_cameras.length > 0) return;
  try {
    _cameras = await availableCameras();
  } catch (e) {
    print("camera is not supported");
  }
}

int cameraCounts() {
  return _cameras.length;
}

CameraDescription? getCameraDescription(int index) {
  if (_cameras.isEmpty) return null;
  return _cameras[index];
}

Future<void> onNewCameraSelected(
    CameraController? cameraController, int index) async {
  if (cameraController != null) {
    await cameraController.setDescription(_cameras[index]);
  } else {
    cameraController = await getCameraController();
  }
}

Future<CameraController?> getCameraController({int index = 0}) async {
  if (_cameras.isEmpty) return null;
  if (index >= _cameras.length) return null;
  CameraController controller = CameraController(
    _cameras[index],
    kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
    imageFormatGroup: ImageFormatGroup.jpeg,
  );
  await controller.initialize();
  if (kIsWeb) return controller;
  await Future.wait(<Future<Object?>>[
    // The exposure mode is currently not supported on the web.

    controller
        .getMaxZoomLevel()
        .then((double value) => MAX_AVAILBLE_ZOOM = value),
    controller
        .getMinZoomLevel()
        .then((double value) => MIN_AVAILBLE_ZOOM = value),
  ]);
  return controller;
}

Future<XFile?> onTakingPhoto(CameraController? cameraController) async {
  if (cameraController == null || !cameraController.value.isInitialized)
    return null;
  if (cameraController.value.isTakingPicture) return null;
  try {
    final XFile file = await cameraController.takePicture();
    print(file);
    return file;
  } on CameraException catch (e) {
    print(e);
    return null;
  }
}

Widget cameraScreen(context, CameraController? cameraController) {
  double scale = 1;
  double currentScale = 1;
  if (cameraController != null &&
      !kIsWeb &&
      MediaQuery.of(context).orientation == Orientation.portrait) {
    var camera = cameraController.value;
    scale = camera.aspectRatio;
  }
  void _handleScaleStart(ScaleStartDetails details) {
    scale = currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (cameraController == null) {
      return;
    }
    currentScale =
        (scale * details.scale).clamp(MIN_AVAILBLE_ZOOM, MAX_AVAILBLE_ZOOM);

    await cameraController.setZoomLevel(currentScale);
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (cameraController == null) return;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  return Container(
      child: (cameraController == null || !cameraController.value.isInitialized)
          ? const Expanded(
              flex: 12,
              child: Center(
                  child: Text(
                "Enable Camera",
                style: TextStyle(color: Colors.white),
              )))
          : Transform.scale(
              scale: scale,
              child: Center(
                  child: CameraPreview(
                cameraController,
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onScaleStart: _handleScaleStart,
                    onScaleUpdate: _handleScaleUpdate,
                    onTapDown: (TapDownDetails details) =>
                        onViewFinderTap(details, constraints),
                  );
                }),
              ))));
}
