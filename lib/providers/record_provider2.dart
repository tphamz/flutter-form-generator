// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:collection';
import 'dart:async';
import 'package:sample/providers/javascript_provider.dart';

class RecordProvider extends JavascriptProvider {
  final int MS_TIMEOUT = 0;
  Map<String, dynamic> record = {};
  Queue<Map<String, dynamic>> queue = Queue();
  bool onConsume = false;

  RecordProvider() : super();

  setRecord(Map<String, dynamic> record) {
    this.record = record;
  }

  void onChange(String key, dynamic value, dynamic jsValue) {
    //set value for app env
    record[key] = value;
    //set value for js env
    setValue(key, jsValue);
    if (elementsProvider?.dependencies[key] != null)
      elementsProvider?.dependencies[key]?.forEach((k, v) {
        queue.add({"name": k, "conditions": v.values});
      });
    consume();
  }

  void consume() {
    if (queue.isEmpty) {
      // onConsume = false;
      return;
    }
    // if (onConsume) return;
    // onConsume = true;
    // handleConsume();
    Timer(Duration(milliseconds: MS_TIMEOUT), () => handleConsume());
  }

  void handleConsume() {
    if (queue.isEmpty) return;
    // print("consume");
    Map<String, dynamic> value = queue.removeFirst();
    elementsProvider?.senders[value["name"]]?.add(value["conditions"]);
    consume();
  }
}
