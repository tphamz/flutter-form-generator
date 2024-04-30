// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sample/utilities/camera.dart';
import 'package:sample/utilities/photo_preview.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  XFile? photo;
  final ThemeData base = ThemeData();
  FlashMode flashMode = FlashMode.off;
  int currentCamera = 0;

  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
    super.dispose();
    // cameraController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

  Future<void> onPhotoAction(XFile? photo) async {
    setState(() {
      this.photo = photo;
    });
  }

  onPhotoPreviewAction(value) {
    print("onPhotoPreviewAction::$value");
    if (value == null)
      setState(() => {photo = null});
    else
      Navigator.pop(context, value);
  }

  Widget blankScreen() {
    return const Expanded(flex: 1, child: Center(child: Text("Enable Camera")));
  }

  Widget displaycamera() {
    return Stack(
      children: <Widget>[
        cameraScreen(context, cameraController),
        Positioned(
            top: 80,
            left: 10,
            right: 10,
            child: TopAction(cameraController: cameraController)),
        Positioned(
            bottom: 100,
            left: 10,
            right: 10,
            child: BottomAction(
                cameraController: cameraController,
                onPhotoAction: onPhotoAction)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Dialog.fullscreen(
      child: photo == null
          ? Container(
              color: Colors.black,
              child: FutureBuilder<CameraController?>(
                  future: getCameraController(index: currentCamera),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      cameraController = snapshot.data;
                      cameraController?.lockCaptureOrientation();
                    }
                    if (snapshot.connectionState != ConnectionState.done)
                      return blankScreen();

                    return displaycamera();
                  }),
            )
          : PhotoPreview(photo: photo, onAction: onPhotoPreviewAction));
}

class TopAction extends StatefulWidget {
  final CameraController? cameraController;
  const TopAction({super.key, this.cameraController});
  @override
  TopActionState createState() => TopActionState();
}

class TopActionState extends State<TopAction> {
  FlashMode flashMode = FlashMode.off;
  Future onSwitchFlash() async {
    if (widget.cameraController?.value.flashMode == FlashMode.off)
      flashMode = FlashMode.always;
    else if (widget.cameraController?.value.flashMode == FlashMode.always)
      flashMode = FlashMode.auto;
    else
      flashMode = FlashMode.off;
    try {
      await widget.cameraController!.setFlashMode(flashMode);
    } on CameraException catch (e) {
      print(e);
    }
    setState(() {});
  }

  Icon getFlashIcon() {
    switch (widget.cameraController?.value.flashMode) {
      case FlashMode.always:
        return const Icon(Icons.flash_on);
      case FlashMode.auto:
        return const Icon(Icons.flash_auto);
      default:
        return const Icon(Icons.flash_off);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
            iconSize: 30,
            color: Colors.grey[100],
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.clear)),
        !kIsWeb
            ? IconButton(
                iconSize: 30,
                color: Colors.grey[100],
                onPressed: onSwitchFlash,
                icon: getFlashIcon())
            : Container(),
      ],
    ));
  }
}

class BottomAction extends StatefulWidget {
  final CameraController? cameraController;
  final dynamic onPhotoAction;
  BottomAction({super.key, this.cameraController, this.onPhotoAction});

  @override
  BottomActionState createState() => BottomActionState();
}

class BottomActionState extends State<BottomAction> {
  int currentCamera = 0;
  final ImagePicker picker = ImagePicker();

  Future<void> onPhotoAction(String actionName) async {
    switch (actionName) {
      case "photo:camera":
        XFile? photo = await onTakingPhoto(widget.cameraController);
        widget.onPhotoAction(photo);
        return;
      case "photo:library":
        final XFile? photo =
            await picker.pickImage(source: ImageSource.gallery);
        widget.onPhotoAction(photo);
        return;
      default:
    }
  }

  onSwitchCamera() {
    currentCamera = (currentCamera + 1) % 2;
    onNewCameraSelected(widget.cameraController, currentCamera);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
            iconSize: 30,
            color: Colors.grey[100],
            onPressed: () => onPhotoAction("photo:library"),
            icon: const Icon(Icons.photo_library_outlined)),
        Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(50.0))),
            child: InkWell(
              child: Container(
                margin: const EdgeInsets.all(2.0),
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
              ),
              onTap: () => onPhotoAction("photo:camera"),
            )),
        !kIsWeb
            ? IconButton(
                iconSize: 30,
                color: Colors.grey[100],
                onPressed: onSwitchCamera,
                icon: const Icon(Icons.change_circle))
            : Container()
      ],
    ));
  }
}
