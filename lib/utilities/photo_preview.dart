import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'dart:io';

import 'package:camera/camera.dart';

class PhotoPreview extends StatefulWidget {
  final XFile? photo;
  final dynamic onAction;
  const PhotoPreview({super.key, this.photo, this.onAction});
  @override
  PhotoPreviewState createState() => PhotoPreviewState();
}

class PhotoPreviewState extends State<PhotoPreview> {
  dynamic xFileToImage(XFile? data) {
    if (data == null) return Container();
    return kIsWeb ? Image.network(data.path) : Image.file(File(data.path));
  }

  Widget topAction() => Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
              iconSize: 30,
              color: Colors.grey[100],
              onPressed: () => {widget.onAction(null)},
              icon: const Icon(Icons.arrow_back_ios))
        ],
      ));

  Widget bottomAction() => Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          SizedBox(
              height: 50,
              width: 50,
              child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () => widget.onAction(widget.photo),
                  child: Icon(
                    Icons.done,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ))),
          const Spacer()
        ],
      ));
  @override
  Widget build(context) => Container(
      color: Colors.black,
      child: Stack(children: <Widget>[
        Positioned(top: 80, left: 10, right: 10, child: topAction()),
        Center(child: xFileToImage(widget.photo)),
        Positioned(bottom: 100, left: 10, right: 10, child: bottomAction()),
      ]));
}
