import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import 'package:sample/components/elements/form_element.dart';
import 'package:sample/providers/record_provider.dart';
import 'dart:typed_data';

class SignatureElement extends FormElement {
  const SignatureElement({super.key, required super.element});

  @override
  SignatureElementState createState() => SignatureElementState();
}

class SignatureElementState extends FormElementState<SignatureElement> {
  bool onDrawing = false;
  SignatureController? _controller;

  SignatureElementState() : super() {
    _controller = SignatureController(
      penStrokeWidth: 1,
      exportBackgroundColor: Colors.grey[200],
      exportPenColor: Colors.black,
      onDrawStart: () => {setState(() => onDrawing = true)},
    );
  }

  @override
  void dispose() {
    // IMPORTANT to dispose of the controller
    _controller?.dispose();
    super.dispose();
  }

  clearSignature() {
    setState(() {
      onDrawing = false;
      _controller?.clear();
    });
  }

  Future<void> exportImage(BuildContext context) async {
    if (_controller?.isEmpty ?? true) return;

    final Uint8List? data =
        await _controller?.toPngBytes(height: 260, width: 1000);
    onDrawing = false;
    _controller?.clear();
    onChanged(data);
    // print(base64.encode(data ?? []));
  }

  @override
  Widget render(BuildContext context, RecordProvider recordState) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            alignment: Alignment.centerLeft,
            child: Text(
                '${widget.element.label}${widget.element.is_required == true ? "*" : ""}',
                style: const TextStyle(fontSize: 14),
                textDirection: TextDirection.ltr)),
        ClipRect(
          child: Container(
              padding: const EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: onDrawing
                          ? Theme.of(context).primaryColor
                          : Colors.transparent)),
              child: (recordState.record[widget.element.name] != null)
                  ? Image.memory(recordState.record[widget.element.name])
                  : Signature(
                      controller: _controller ?? SignatureController(),
                      height: 200,
                      backgroundColor: Colors.grey[300]!,
                    )),
        ),
        Container(
            margin: const EdgeInsets.only(top: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const Spacer(),
                  if (recordState.record[widget.element.name] == null)
                    TextButton.icon(
                      key: const Key('clear'),
                      icon: const Icon(Icons.clear),
                      onPressed: onDrawing ? () => clearSignature() : null,
                      label: const Text('Clear'),
                    ),
                  const SizedBox(width: 15),
                  if (recordState.record[widget.element.name] == null)
                    TextButton.icon(
                        key: const Key('exportPNG'),
                        icon: const Icon(Icons.check),
                        onPressed:
                            onDrawing ? () => exportImage(context) : null,
                        label: const Text('Confirm Signature')),
                  if (recordState.record[widget.element.name] != null)
                    TextButton.icon(
                      key: const Key('exportPNG'),
                      icon: const Icon(Icons.create),
                      onPressed: () => onChanged(null),
                      label: const Text('New Signature'),
                    )
                ]))
      ],
    );
  }
}
