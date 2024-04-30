import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sample/components/elements/form_element.dart';
import 'package:sample/providers/record_provider.dart';

class DateTimeElement extends FormElement {
  const DateTimeElement({super.key, required super.element});

  @override
  DateTimeElementState createState() => DateTimeElementState();
}

class DateTimeElementState extends FormElementState<DateTimeElement> {
  final ThemeData base = ThemeData();

  String dateToString(DateTime value) {
    return '${value.year.toString()}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  }

  String timeToString(dynamic value) {
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}:00';
  }

  DateTime initialDate() {
    var recordState = Provider.of<RecordProvider>(context, listen: false);
    String value = "";
    if (recordState.record[widget.element.name] != null)
      value = recordState.record[widget.element.name];
    if (value == "") return DateTime.now();
    return DateTime.parse(value);
  }

  TimeOfDay initialTime() {
    var recordState = Provider.of<RecordProvider>(context, listen: false);
    String value = "";
    if (recordState.record[widget.element.name] != null)
      value = recordState.record[widget.element.name];
    if (value == "") return TimeOfDay.now();
    DateTime date = DateTime.parse(value);
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }

  onOpenDateTimeDialog(BuildContext context, RecordProvider recordState) async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDate: initialDate(),
        firstDate: DateTime.parse('2000-01-01'),
        lastDate: DateTime.parse('2500-01-01'));
    if (date == null) return;
    if (context.mounted) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: initialTime(),
        builder: (BuildContext ctxt, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(ctxt).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );
      if (time == null) return;
      onChanged('${dateToString(date)} ${timeToString(time)}');
    }
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
                            Text(recordState.record[widget.element.name] ??
                                "Select Date Time")
                          ]))),
                  onTap: () async {
                    await onOpenDateTimeDialog(context, recordState);
                  },
                ))),
      ],
    );
  }
}
