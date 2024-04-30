import 'package:flutter_js/flutter_js.dart';

class JSService {
  static JavascriptRuntime runtime = getJavascriptRuntime();
  static String eval(String statement) {
    return runtime
        .evaluate('try{$statement}catch(err){"@error::"+err.message;}')
        .stringResult;
  }
}
