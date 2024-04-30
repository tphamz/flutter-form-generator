import 'dart:convert';

class OptionModel {
  final int id;
  final int sort_order;
  final int score;
  final String global_id;
  final String key_value;
  final String label;
  final String condition_value;

  OptionModel(this.id, this.sort_order, this.score, this.global_id,
      this.key_value, this.label, this.condition_value);

  OptionModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        sort_order = json["sort_order"],
        global_id = json["global_id"],
        score = json["score"],
        key_value = json["key_value"],
        label = json["label"],
        condition_value = json["condition_value"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "sort_order": sort_order,
        "global_id": global_id,
        "score": score,
        "key_value": key_value,
        "label": label,
        "condition_value": condition_value
      };

  @override
  bool operator ==(dynamic other) => key_value == other.key_value;

  @override
  int get hashCode => id;

  @override
  String toString() {
    // TODO: implement toString
    return json.encode(toJson());
  }
}
