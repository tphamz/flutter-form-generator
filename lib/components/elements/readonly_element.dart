import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sample/components/elements/form_element.dart';
import 'package:sample/providers/record_provider.dart';

class ReadOnlyElement extends FormElement {
  const ReadOnlyElement({super.key, required super.element});

  @override
  ReadOnlyElementState createState() => ReadOnlyElementState();
}

class ReadOnlyElementState extends FormElementState<ReadOnlyElement> {
  final TextEditingController _controller = TextEditingController();
  String? record;

  @override
  Widget render(BuildContext context, RecordProvider recordState) {
    print("ReadOnlyElement::render");
    _controller.text = (recordState.record[widget.element.name] == null)
        ? ""
        : recordState.record[widget.element.name].toString();
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
    return TextFormField(
        readOnly: true,
        enabled: false,
        controller: _controller,
        onChanged: (String? value) {
          onChanged(value);
        },
        decoration: InputDecoration(
          filled: true,
          border: const OutlineInputBorder(),
          labelText:
              '${widget.element.label}${widget.element.is_required == true ? "*" : ""}',
        ));
  }
}
