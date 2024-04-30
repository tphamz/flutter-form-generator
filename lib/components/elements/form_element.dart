// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sample/models/element_model.dart';
import 'package:sample/providers/record_provider.dart';

abstract class FormElement extends StatefulWidget {
  final ElementModel element;
  const FormElement({super.key, required this.element});

  @override
  State<FormElement> createState();
}

abstract class FormElementState<T extends FormElement> extends State<T> {
  StreamSubscription<Map<String, dynamic>>? subscriber;

  @override
  Widget build(BuildContext context) {
    var recordState = Provider.of<RecordProvider>(context, listen: false);
    return renderContainer(context, recordState);
  }

  @override
  void dispose() {
    super.dispose();
    subscriber?.cancel();
  }

  @override
  void initState() {
    super.initState();
    final recordState = Provider.of<RecordProvider>(context, listen: false);
    onInit();
    Stream<Map<String, dynamic>>? receiver = recordState.receiver;
    if (receiver != null) {
      subscriber = receiver.listen((Map<String, dynamic> data) {
        onReceiveEvent(data);
      });
    }
  }

  onChanged(dynamic value) {
    final recordState = Provider.of<RecordProvider>(context, listen: false);
    recordState.onChange(widget.element.name, value, toJsValue(value));
  }

  onReceiveEvent(Map<String, dynamic> data) {
    String name = widget.element.name;
    String eventElem = data["name"];
    if (eventElem == "") return;
    Map<String, bool>? dependencies = widget.element.dependencies[eventElem];
    if (dependencies == null) {
      if (eventElem == name) return setState(() {});
      return;
    }
    if (eventElem == name) {
      Map<String, bool> copiedDependencies = Map.from(dependencies);
      copiedDependencies.remove("dynamic_value");
      handleDependencies(copiedDependencies);
    } else
      handleDependencies(dependencies);
    return setState(() {});
  }

  onInit() {
    if (widget.element.dependencies["_init"] != null) {
      handleDependencies(widget.element.dependencies["_init"]);
    }
  }

  void handleDependencies(Map<String, bool>? dependencies) {
    if (dependencies == null) return;
    final recordState = Provider.of<RecordProvider>(context, listen: false);
    if (dependencies["dynamic_value"] == true &&
        widget.element.dynamic_value != "") {
      String statement = widget.element.dynamic_value ?? "";
      String result = recordState.eval(statement);
      // print("handleDependencies::dynamic_value::$result");
      if (!result.contains("@error") &&
          recordState.record[widget.element.name] != toElementValue(result))
        onChanged(toElementValue(result));
    }
    if (dependencies["dynamic_label"] == true &&
        widget.element.dynamic_label != "") {
      String result = recordState.eval(widget.element.dynamic_label ?? "");
      // print("handleDependencies::dynamic_label::$result");
      if (!result.contains("@error")) widget.element.label = result;
    }

    if (dependencies["attachment_link"] == true &&
        widget.element.dynamic_label != "") {
      String result =
          recordState.eval("`${(widget.element.attachment_link ?? "")}`");
      // print("handleDependencies::attachment_link::$result");
      if (!result.contains("@error")) widget.element.attachmentLink = result;
    }

    if (dependencies["condition_value"] == true &&
        widget.element.condition_value != "") {
      // print("statement::${(widget.element.condition_value ?? "")}");
      String result = recordState.eval((widget.element.condition_value ?? ""));
      // print(
      //     "${widget.element.name}::handleDependencies::condition_value::$result");
      if (!result.contains("@error"))
        widget.element.is_disabled = !handleJsBool(result);
    }

    if (dependencies["client_validation"] == true &&
        widget.element.client_validation != "") {
      String result = recordState.eval(widget.element.client_validation ?? "");
      // print("handleDependencies::client_validation::$result");
      if (!result.contains("@error")) {
        bool val = handleJsBool(result);
        if (!val) {
          widget.element.hasError = true;
          if (dependencies["validation_message"] == true &&
              widget.element.validation_message != "") {
            result = recordState.eval(widget.element.validation_message ?? "");
            // print("handleDependencies::validation_message::$result");
            if (!result.contains("@error"))
              widget.element.validationMessage = result;
          }
        } else {
          widget.element.validationMessage = "";
          widget.element.hasError = false;
        }
      }
    }
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

  //overridable
  String? showErrorMessage(val) {
    if (widget.element.is_required == true && (val == null)) return "";
    if (widget.element.hasError) return widget.element.validationMessage;
    return null;
  }

  //overridable
  dynamic toElementValue(String jsValue) {
    return jsValue;
  }

  //overridable
  dynamic toJsValue(dynamic elementValue) {
    return elementValue;
  }

  //overridable
  Widget render(BuildContext context, RecordProvider recordState);
}
