import 'package:flutter/material.dart';

import 'package:sample/components/elements/form_element.dart';
import 'package:sample/providers/record_provider.dart';

class TimeElement extends FormElement {
  const TimeElement({super.key, required super.element});

  @override
  TimeElementState createState() => TimeElementState();
}

class TimeElementState extends FormElementState<TimeElement> {
  final ThemeData base = ThemeData();

  String timeToString(TimeOfDay? value) {
    if (value == null) return "Select time";
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  @override
  dynamic toElementValue(String jsValue) {
    try {
      List<String> tmp = jsValue.split(":");
      return TimeOfDay(
          hour: int.tryParse(tmp[0]) ?? 0, minute: int.tryParse(tmp[1]) ?? 0);
    } catch (err) {
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }

  @override
  dynamic toJsValue(dynamic elementValue) {
    return "${elementValue.hour.toString().padLeft(2, '0')}:${elementValue.minute.toString().padLeft(2, '0')}";
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
                                child: Icon(Icons.access_time, size: 24.0)),
                            Text(timeToString(
                                recordState.record[widget.element.name]))
                          ]))),
                  onTap: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialEntryMode: TimePickerEntryMode.input,
                      initialTime: recordState.record[widget.element.name] ??
                          TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      },
                    );
                    onChanged(time);
                  },
                ))),
      ],
    );
  }
}
