import 'dart:js' as js;

class JSService {
  static String eval(String statement) {
    return js.context.callMethod("eval", [statement]).toString();
  }
}
