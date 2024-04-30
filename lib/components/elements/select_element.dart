import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:sample/providers/options_provider.dart';
import 'package:sample/providers/package_provider.dart';

import 'package:sample/models/option_model.dart';

import 'package:sample/components/elements/form_element.dart';
import 'package:sample/providers/record_provider.dart';

class SelectElement extends FormElement {
  const SelectElement({super.key, required super.element});

  @override
  SelectElementState createState() => SelectElementState();
}

class SelectElementState extends FormElementState<SelectElement> {
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
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
                '${widget.element.label}${widget.element.is_required == true ? "*" : ""}',
                style: const TextStyle(height: 2, fontSize: 12),
                textDirection: TextDirection.ltr)),
        Wrap(
            spacing: 8,
            children: (optionsProvider?.options ?? [])
                .map((OptionModel value) => RadioListTile<OptionModel>(
                      title: Text(value.label),
                      value: value,
                      groupValue: recordState.record[widget.element.name],
                      onChanged: (OptionModel? value) => onChanged(value),
                    ))
                .toList())
      ],
    );
  }
}
