// ignore_for_file: curly_braces_in_flow_control_structures

import "dart:collection";
import 'package:flutter/material.dart';
import 'package:sample/providers/elements_provider.dart';
import 'package:sample/services/js_service.dart'
    if (dart.library.html) 'package:sample/services/webjs_service.dart'
    if (dart.library.io) 'package:sample/services/osjs_service.dart';

class JavascriptProvider {
  final statement = Queue<Map<String, String>>();
  String pageLevel = "";
  Map<String, dynamic>? page = {};
  ElementsProvider? elementsProvider;

  setup(
      {required elementsProvider,
      String pageLevel = "",
      required Map<String, dynamic>? page,
      int index = 0,
      String data = "{}"}) {
    this.elementsProvider = elementsProvider;
    if (page == null)
      this.page = {};
    else
      this.page = page;
    this.pageLevel = pageLevel;
    String name = this.page?["name"];
    String script = this.page?["page_javascript"];
    if (pageLevel == "") {
      JSService.eval('$script;var $name = $data;');
    } else {
      JSService.eval('if(!$pageLevel.$name) $pageLevel.$name=[];');
      JSService.eval(
          'if($index==$pageLevel.$name.length){var $name = $data;$pageLevel.$name.push($name);}else{$name=$pageLevel.$name[$index];}');
    }
    return this;
  }

  setValue(String name, dynamic value) {
    String statement = "$name =";
    switch (value.runtimeType) {
      case String:
        statement = '$statement "$value"';
        break;
      case int:
      case double:
        statement = '$statement $value';
        break;
      default:
        statement = '$statement ${value.toString()}';
    }
    JSService.eval("var $statement");

    String pageName = page?["name"];
    JSService.eval('$pageName.$statement');
    if (pageLevel != "") JSService.eval('$pageLevel.$pageName.$statement');
  }

  String eval(String statement) {
    return JSService.eval('try{$statement}catch(err){"@error::"+err.message;}');
  }
}
