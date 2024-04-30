import 'package:flutter/material.dart';

import 'package:sample/components/elements/form_element.dart';
import 'package:sample/providers/record_provider.dart';

class TextElement extends FormElement {
  const TextElement({super.key, required super.element});

  @override
  TextElementState createState() => TextElementState();
}

class TextElementState extends FormElementState<TextElement> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget render(BuildContext context, RecordProvider recordState) {
    // return Text(recordState.record[widget.element.name] ?? "");
    _controller.text =
        (recordState.record[widget.element.name] ?? "").toString();
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
    return TextFormField(
        controller: _controller,
        onChanged: (String? value) {
          onChanged(value);
        },
        decoration: InputDecoration(
          errorText: showErrorMessage(recordState.record[widget.element.name]),
          border: const OutlineInputBorder(),
          labelText:
              '${widget.element.label}${widget.element.is_required == true ? "*" : ""}',
        ),
        validator: (text) {
          if ((text == "" || text == null) &&
              widget.element.is_required == true) return "Field is required!";
          if (widget.element.hasError) return widget.element.validationMessage;
          return null;
        });
  }
}
