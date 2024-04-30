// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:sample/models/dependent_condition_model.dart';

class DependencyProvider {
  Map<String, Map<String, DependentConditionModel>> dependencies = {};

  void findDependencies(
      String pageName, List<String> keywords, Map<String, dynamic> elem) {
    findDependency(pageName, "dynamic_value", keywords, elem);
    findDependency(pageName, "condition_value", keywords, elem);
    findDependency(pageName, "dynamic_label", keywords, elem);
    findDependency(pageName, "condition_value", keywords, elem);
    findDependency(pageName, "validation_message", keywords, elem);
    findDependency(pageName, "client_validation", keywords, elem);
    findDependency(pageName, "attachment_link", keywords, elem);
  }

  void findDependency(String pageName, String condition, List<String> keywords,
      Map<String, dynamic> elem) {
    var statement = elem[condition];
    if (statement == null || statement == "") return;
    List<String> rawElements = statementToElements(statement);
    bool hasDependency = false;
    for (String val in keywords) {
      if (rawElements.contains(val) || rawElements.contains("$pageName.$val")) {
        hasDependency = true;
        if (val == elem["name"] && condition == "dynamic_value") {
          if (dependencies['_init'] == null)
            dependencies['_init'] = {val: DependentConditionModel()};
          dependencies['_init']?[val]?.addValue(condition);
          continue;
        }
        if (dependencies[val] == null)
          dependencies[val] = {elem["name"]: DependentConditionModel()};
        if (dependencies[val]?[elem["name"]] == null)
          dependencies[val]?[elem["name"]] = DependentConditionModel();
        dependencies[val]?[elem["name"]]?.addValue(condition);
      }
    }
    if (hasDependency) return;
    if (dependencies['_init'] == null)
      dependencies['_init'] = {elem["name"]: DependentConditionModel()};
    dependencies['_init']?[elem["name"]]?.addValue(condition);
  }

  List<String> statementToElements(String statement) {
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
