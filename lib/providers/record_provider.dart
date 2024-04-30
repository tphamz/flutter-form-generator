import 'dart:collection';
import 'dart:async';
import 'package:sample/providers/javascript_provider.dart';

class RecordProvider extends JavascriptProvider {
  final int TIMEOUT_LIMIT = 0;
  Map<String, dynamic> record = {};
  Queue<Map<String, dynamic>> queue = Queue();
  bool onConsume = false;
  StreamController<Map<String, dynamic>> sender =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>>? receiver;

  RecordProvider() : super() {
    receiver = sender.stream;
  }

  setRecord(Map<String, dynamic> record) {
    this.record = record;
  }

  void onChange(String key, dynamic value, dynamic jsValue) {
    //set value for app env
    record[key] = value;
    //set value for js env
    setValue(key, jsValue);
    queue.add({"name": key, "value": value});
    consume();
  }

  void consume() {
    if (queue.isEmpty) {
      onConsume = false;
      return;
    }
    // if (onConsume) return;
    // onConsume = true;
    Future.delayed(
        Duration(microseconds: TIMEOUT_LIMIT), () => handleConsume());
  }

  void handleConsume() {
    if (queue.isEmpty) {
      onConsume = false;
      return;
    }
    print("consume");
    sender.add(queue.removeFirst());
    consume();
  }
}
