import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sample/components/elements/form_element.dart';
import 'package:sample/providers/record_provider.dart';

class AttachmentElement extends FormElement {
  const AttachmentElement({super.key, required super.element});

  @override
  AttachmentElementState createState() => AttachmentElementState();
}

class AttachmentElementState extends FormElementState<AttachmentElement> {
  final ThemeData base = ThemeData();
  @override
  Widget render(BuildContext context, RecordProvider recordState) {
    return Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(color: base.focusColor),
            borderRadius: const BorderRadius.all(Radius.circular(5.0) //
                )),
        child: InkWell(
            onTap: () => launchUrl(Uri.parse(widget.element.attachmentLink == ""
                ? (widget.element.attachment_link ?? "")
                : widget.element.attachmentLink)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  '${widget.element.label}${widget.element.is_required == true ? "*" : ""}',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            )));
  }
}
