// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sample/models/element_model.dart';
import 'package:sample/providers/record_provider2.dart';
import 'package:sample/providers/elements_provider2.dart';

abstract class FormElement extends StatefulWidget {
  final ElementModel element;
  const FormElement({super.key, required this.element});

  @override
  State<FormElement> createState();
}

abstract class FormElementState<T extends FormElement> extends State<T> {
  StreamController? sender;
  StreamSubscription? subscriber;

  @override
  void initState() {
    String elemName = widget.element.name;
    final elementsProvider =
        Provider.of<ElementsProvider>(context, listen: false);
    sender = elementsProvider.senders[elemName];
    Stream? receiver = elementsProvider.receivers[elemName];
    if (receiver != null) {
      if (elementsProvider.dependencies["_init"] != null &&
          elementsProvider.dependencies["_init"]?[elemName] != null)
        onReceiveEvent(
            elementsProvider.dependencies["_init"]?[elemName]?.values ?? []);

      subscriber = receiver.listen((dynamic data) {
        onReceiveEvent(data);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var recordState = Provider.of<RecordProvider>(context, listen: false);
    return renderContainer(context, recordState);
  }

  @override
  void dispose() {
    super.dispose();
    sender?.close();
    subscriber?.cancel();
  }

  onChanged(String key, dynamic value) {
    var recordState = Provider.of<RecordProvider>(context, listen: false);
    recordState.onChange(key, value, toJsValue(value));
    setState(() {});
  }

  onReceiveEvent(List<dynamic> data) {
    print("onReceiveEvent");
    bool reloadRequired = false;
    for (dynamic condition in data)
      reloadRequired = handleDependency(condition.toString()) || reloadRequired;
    if (reloadRequired) setState(() {});
  }

  bool handleDependency(String condition) {
    var recordState = Provider.of<RecordProvider>(context, listen: false);
    if (condition == "dynamic_value" && widget.element.dynamic_value != "") {
      String statement = widget.element.dynamic_value ?? "";
      String result = recordState.eval(statement);
      if (!result.contains("@error")) {
        dynamic res = toElementValue(result);
        if (res != recordState.record[widget.element.name]) {
          recordState.onChange(widget.element.name, res, result);
          return true;
        }
      }
      return false;
    }
    if (condition == "dynamic_label" && widget.element.dynamic_label != "") {
      String result = recordState.eval(widget.element.dynamic_label ?? "");
      // print("handleDependencies::dynamic_label::$result");
      if (!result.contains("@error") && widget.element.label != result) {
        widget.element.label = result;
        return true;
      }
      return false;
    }

    if (condition == "attachment_link" && widget.element.dynamic_label != "") {
      String result =
          recordState.eval("`${(widget.element.attachment_link ?? "")}`");
      // print("handleDependencies::attachment_link::$result");
      if (!result.contains("@error") &&
          widget.element.attachmentLink != result) {
        widget.element.attachmentLink = result;
        return true;
      }
      return false;
    }

    if (condition == "condition_value" &&
        widget.element.condition_value != "") {
      // print("statement::${(widget.element.condition_value ?? "")}");
      String result = recordState.eval((widget.element.condition_value ?? ""));
      // print("handleDependencies::condition_value::$result");
      if (!result.contains("@error")) {
        bool res = !handleJsBool(result);
        if (widget.element.is_disabled != res) {
          widget.element.is_disabled = res;
          return true;
        }
      }
      return false;
    }

    if (condition == "client_validation" &&
        widget.element.client_validation != "") {
      String result = recordState.eval(widget.element.client_validation ?? "");
      // print("handleDependencies::client_validation::$result");
      if (!result.contains("@error")) {
        bool val = handleJsBool(result);
        if (!val) {
          widget.element.hasError = true;
          if (widget.element.validation_message != null &&
              widget.element.validation_message != "") {
            result = recordState.eval(widget.element.validation_message ?? "");
            // print("handleDependencies::validation_message::$result");
            if (!result.contains("@error") &&
                widget.element.validationMessage != result) {
              widget.element.validationMessage = result;
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  Widget renderContainer(BuildContext context, RecordProvider recordState) {
    return Column(children: [
      if (widget.element.is_disabled != true) render(context, recordState)
    ]);
  }

  bool handleJsBool(String val) {
    if (val == "false" || val == "" || val == "0") return false;
    return true;
  }

  String? showErrorMessage(val) {
    if (widget.element.is_required == true && (val == null)) return "";
    if (widget.element.hasError) return widget.element.validationMessage;
    return null;
  }

  // for overriding
  dynamic toElementValue(String jsValue) {
    return jsValue;
  }

  dynamic toJsValue(dynamic elementValue) {
    return elementValue;
  }

  //for overriding
  Widget render(BuildContext context, RecordProvider recordState);
}
