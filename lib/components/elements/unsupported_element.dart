import 'package:flutter/material.dart';
import 'package:sample/components/elements/form_element.dart';
import 'package:sample/providers/record_provider.dart';

class UnsupportedElement extends FormElement {
  const UnsupportedElement({super.key, required super.element});

  @override
  UnsupportedElementState createState() => UnsupportedElementState();
}

class UnsupportedElementState extends FormElementState<UnsupportedElement> {
  @override
  Widget render(BuildContext context, RecordProvider recordState) => Container(
      height: 50,
      padding: const EdgeInsets.all(5.0),
      width: double.infinity,
      color: Colors.grey[200],
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "${widget.element.label}${widget.element.is_required == true ? "*" : ""} (Unsupported Element)",
          style: const TextStyle(color: Colors.grey),
        ),
      ));
}
