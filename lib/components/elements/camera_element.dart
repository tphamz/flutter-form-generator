import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

import 'package:sample/components/elements/form_element.dart';
import 'package:sample/providers/record_provider.dart';
import 'package:sample/utilities/camera_screen.dart';

class CameraElement extends FormElement {
  const CameraElement({super.key, required super.element});

  @override
  CameraElementState createState() => CameraElementState();
}

class CameraElementState extends FormElementState<CameraElement> {
  @override
  dynamic toJsValue(dynamic elementValue) {
    return elementValue.path;
  }

  final ThemeData base = ThemeData();

  Future<void> handleTakingPhoto() async {
    XFile? data = await showDialog(
        context: context,
        useSafeArea: false,
        builder: (BuildContext ctxt) =>
            const Dialog.fullscreen(child: CameraScreen()));

    if (data != null) {
      onChanged(File(data.path));
    }
  }

  @override
  Widget render(BuildContext context, RecordProvider recordState) {
    return Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(bottom: 8.0),
          child: Text(
              '${widget.element.label}${widget.element.is_required == true ? "*" : ""}',
              style: const TextStyle(fontSize: 14),
              textDirection: TextDirection.ltr)),
      Material(
          child: Container(
              constraints: const BoxConstraints(
                  minHeight: 50, minWidth: double.infinity),
              decoration: BoxDecoration(
                  border: Border.all(color: base.focusColor),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0) //
                      )),
              child: InkWell(
                onTap: handleTakingPhoto,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(children: const [
                          Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.camera_alt, size: 24.0)),
                          Text("New Photo")
                        ]))),
              ))),
      recordState.record[widget.element.name] != null
          ? Container(
              color: Colors.black,
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        child: recordState
                                    .record[widget.element.name].runtimeType ==
                                String
                            ? Image.network(
                                recordState.record[widget.element.name],
                                height: 200,
                                fit: BoxFit.fill)
                            : kIsWeb
                                ? Image.network(
                                    recordState
                                        .record[widget.element.name].path,
                                    height: 200,
                                    fit: BoxFit.fill)
                                : Image.file(
                                    recordState.record[widget.element.name],
                                    height: 200,
                                    fit: BoxFit.fill),
                      ))))
          : Container(),
    ]);
  }
}
