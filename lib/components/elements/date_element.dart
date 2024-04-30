import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sample/components/elements/form_element.dart';
import 'package:sample/providers/record_provider.dart';

class DateElement extends FormElement {
  const DateElement({super.key, required super.element});

  @override
  DateElementState createState() => DateElementState();
}

class DateElementState extends FormElementState<DateElement> {
  final ThemeData base = ThemeData();

  String dateToString(DateTime? value) {
    if (value == null) return "Select Date";
    return '${value.year.toString()}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  }

  @override
  dynamic toElementValue(String jsValue) {
    try {
      return DateTime.tryParse(jsValue);
    } catch (err) {
      return null;
    }
  }

  @override
  dynamic toJsValue(dynamic elementValue) {
    var recordState = Provider.of<RecordProvider>(context, listen: false);
    if (elementValue == null) return recordState.record[widget.element.name];
    return '${elementValue.year.toString()}-${elementValue.month.toString().padLeft(2, '0')}-${elementValue.day.toString().padLeft(2, '0')}';
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
        Material(
            child: Container(
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: base.focusColor),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0) //
                        )),
                child: InkWell(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(children: [
                            const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.calendar_month_rounded,
                                    size: 24.0)),
                            Text(dateToString(
                                recordState.record[widget.element.name]))
                          ]))),
                  onTap: () async {
                    final DateTime? date = await showDatePicker(
                        context: context,
                        initialEntryMode: DatePickerEntryMode.calendar,
                        initialDate: recordState.record[widget.element.name] ??
                            DateTime.now(),
                        firstDate: DateTime.parse('2000-01-01'),
                        lastDate: DateTime.parse('2500-01-01'));
                    if (date != null) onChanged(date);
                  },
                ))),
      ],
    );
  }
}
