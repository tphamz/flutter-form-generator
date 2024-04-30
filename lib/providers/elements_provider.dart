import 'package:sample/providers/page_provider.dart';
import 'package:sample/models/element_model.dart';
import 'dart:core';
import 'package:flutter/material.dart';

class ElementsProvider {
  PageProvider pageProvider;
  ElementsProvider({required this.pageProvider}) : super();

  List<ElementModel> get elements {
    Map<String, dynamic>? page = pageProvider.page;
    if (page == null || page["page_level"]["name"] == null) return [];
    String pageName = page["page_level"]["name"];
    if (!page.containsKey("elements")) return [];
    List elements = page["elements"]
        .where((i) => i["is_disabled"] == null || !i["is_disabled"])
        .toList();
    List<String> keywords = [];
    for (var ele in elements) {
      String elemName = ele["name"];
      keywords.add(elemName);
    }
    return List<ElementModel>.from(elements.map((element) {
      ElementModel elem = ElementModel.fromJson(element);
      elem.dependencies = dependencies(keywords, element);
      return elem;
    }));
  }

  Map<String, Map<String, bool>> dependencies(
      List<String> keywords, Map<String, dynamic> elem) {
    Map<String, Map<String, bool>> dependency = {};
    dependency = findDependency("condition_value", dependency, keywords, elem);
    dependency = findDependency("dynamic_value", dependency, keywords, elem);
    dependency = findDependency("dynamic_label", dependency, keywords, elem);
    dependency = findDependency("condition_value", dependency, keywords, elem);
    dependency =
        findDependency("validation_message", dependency, keywords, elem);
    dependency =
        findDependency("client_validation", dependency, keywords, elem);
    dependency = findDependency("attachment_link", dependency, keywords, elem);
    return dependency;
  }

  Map<String, Map<String, bool>> findDependency(
      String condition,
      Map<String, Map<String, bool>> dependency,
      List<String> keywords,
      Map<String, dynamic> elem) {
    Map<String, dynamic>? page = pageProvider.page;
    String pageName = page?["page_level"]["name"];
    var statement = elem[condition];
    if (statement == null || statement == "") return dependency;
    List<String> statements = statementToDependencies(statement);
    bool hasDependency = false;
    for (String val in keywords) {
      if (statements.contains(val) || statements.contains("$pageName.$val")) {
        hasDependency = true;
        if (val == elem["name"] && condition == "dynamic_value") {
          if (dependency['_init'] == null) dependency['_init'] = {};
          dependency['_init']?[condition] = true;
          continue;
        }
        if (dependency[val] == null) dependency[val] = {};
        dependency[val]?[condition] = true;
      }
    }
    if (hasDependency) return dependency;
    if (dependency['_init'] == null) dependency['_init'] = {};
    dependency['_init']?[condition] = true;
    return dependency;
  }

  List<String> statementToDependencies(String statement) {
    return statement
        .replaceAll("ZCDisplayKey_", "")
        .replaceAll("ZCDisplayValue_", "")
        .replaceAll(RegExp(r'"([^"]+(?="))"'), "")
        .replaceAll(RegExp(r"'([^']+(?='))'"), "")
        .replaceAll(RegExp(r"[^A-Za-z0-9_\.]"), " ")
        .replaceAll(RegExp(r"\s+"), " ")
        .replaceAll(".key_value", " ")
        .replaceAll(".label", " ")
        .replaceAll(".sort_order", " ")
        .trim()
        .split(" ")
        .where((item) => !isNumeric(item))
        .toList();
  }

  bool isNumeric(String s) {
    try {
      return double.parse(s) != null;
    } catch (e) {
      return false;
    }
  }
}
