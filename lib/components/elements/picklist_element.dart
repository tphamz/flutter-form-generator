import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

import 'package:sample/models/option_model.dart';
import 'package:sample/providers/package_provider.dart';

import 'package:sample/components/elements/form_element.dart';
import 'package:sample/providers/record_provider.dart';
import 'package:sample/providers/options_provider.dart';

class PicklistElement extends FormElement {
  const PicklistElement({super.key, required super.element});

  @override
  PicklistElementState createState() => PicklistElementState();
}

class PicklistElementState extends FormElementState<PicklistElement> {
  OptionsProvider? optionsProvider;

  @override
  void initState() {
    final packageProvider =
        Provider.of<PackageProvider>(context, listen: false);
    optionsProvider =
        OptionsProvider(packageProvider.package, widget.element.optionlist_id);
    super.initState();
  }

  @override
  dynamic toElementValue(String jsValue) {
    try {
      return OptionModel.fromJson(jsonDecode(jsValue));
    } catch (err) {
      return optionsProvider?.options.firstWhere(
          (option) => option.key_value == jsValue || option.label == jsValue);
    }
  }

  @override
  Widget render(BuildContext context, RecordProvider recordState) {
    return Builder(builder: (BuildContext innerContext) {
      return DropdownButtonFormField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            errorText:
                showErrorMessage(recordState.record[widget.element.name]),
            labelText:
                '${widget.element.label}${widget.element.is_required == true ? "*" : ""}',
          ),
          value: recordState.record[widget.element.name],
          onChanged: (dynamic value) => onChanged(value),
          items: optionsProvider?.options
              .map((OptionModel value) => DropdownMenuItem<OptionModel>(
                  value: value, child: Text(value.label)))
              .toList());
    });
  }
}
