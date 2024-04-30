import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sample/components/elements/form_element.dart';
import 'package:sample/providers/record_provider.dart';

class NumberElement extends FormElement {
  const NumberElement({super.key, required super.element});

  @override
  NumberElementState createState() => NumberElementState();
}

class NumberElementState extends FormElementState<NumberElement> {
  final TextEditingController _controller = TextEditingController();
  String? record;

  @override
  dynamic toElementValue(String jsValue) {
    return int.parse(jsValue);
  }

  @override
  dynamic toJsValue(dynamic elementValue) {
    if (elementValue == null || elementValue == "") return 0;
    return (elementValue.runtimeType == num ||
            elementValue.runtimeType == int ||
            elementValue.runtimeType == double)
        ? elementValue
        : num.tryParse(elementValue) ?? 0;
  }

  @override
  Widget render(BuildContext context, RecordProvider recordState) {
    _controller.text = (recordState.record[widget.element.name] == null)
        ? "0"
        : recordState.record[widget.element.name].toString();
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
        if ((text == "" || text == null) && widget.element.is_required == true)
          return "Field is required!";
        if (widget.element.hasError) return widget.element.validationMessage;
        return null;
      },
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }
}
