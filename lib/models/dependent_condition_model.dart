class DependentConditionModel {
  Set<String> conditions = {};

  void addValue(String val) {
    conditions.add(val);
  }

  void removeValue(String val) {
    conditions.remove(val);
  }

  List<String> get values => conditions.toList();
  @override
  String toString() {
    return values.toString();
  }
}
