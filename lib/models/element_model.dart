import 'dart:convert';

class ElementModel {
  final int id;
  final int version;
  final int data_type;
  final int data_size;
  final int sort_order;
  final int? optionlist_id;
  final int? low_value;
  final int? high_value;
  final int? keyboard_type;
  final int? weighted_score;

  final String global_id;
  final String name;
  String label;
  final String? description;
  final String? condition_value;
  final String? dynamic_value;
  final String? client_validation;
  final String? dynamic_label;
  final String? validation_message;
  final String? smart_tbl_search;
  final String? smart_tbl_search_col;
  final String? created_date;
  final String? created_by;
  final String? modified_date;
  final String? modified_by;
  final String? widget_type;
  final String? default_value;
  final String? attachment_link;
  final String? reference_id_1;
  final String? reference_id_2;
  final String? reference_id_3;
  final String? reference_id_4;
  final String? reference_id_5;

  bool? is_disabled;
  final bool? is_readonly;
  final bool? is_required;
  final bool? is_action;
  final bool? is_encrypt;
  final bool? is_hide_typing;
  final List<dynamic>? dynamic_attributes;
  String validationMessage = "";
  String attachmentLink = "";
  bool hasError = false;
  Map<String, Map<String, bool>> dependencies = {};
  ElementModel(
      this.id,
      this.version,
      this.data_type,
      this.data_size,
      this.sort_order,
      this.optionlist_id,
      this.low_value,
      this.high_value,
      this.keyboard_type,
      this.weighted_score,
      this.global_id,
      this.name,
      this.label,
      this.description,
      this.condition_value,
      this.dynamic_value,
      this.client_validation,
      this.dynamic_label,
      this.validation_message,
      this.smart_tbl_search,
      this.smart_tbl_search_col,
      this.created_date,
      this.created_by,
      this.modified_date,
      this.modified_by,
      this.widget_type,
      this.default_value,
      this.attachment_link,
      this.reference_id_1,
      this.reference_id_2,
      this.reference_id_3,
      this.reference_id_4,
      this.reference_id_5,
      this.is_disabled,
      this.is_readonly,
      this.is_required,
      this.is_action,
      this.is_encrypt,
      this.is_hide_typing,
      this.dynamic_attributes);

  ElementModel.fromJson(Map<String, dynamic> json)
      : this.id = json["id"],
        this.version = json["version"],
        this.data_type = json["data_type"],
        this.data_size = json["data_size"],
        this.sort_order = json["sort_order"],
        this.optionlist_id = json["optionlist_id"],
        this.low_value = json["low_value"],
        this.high_value = json["high_value"],
        this.keyboard_type = json["keyboard_type"],
        this.weighted_score = json["weighted_score"],
        this.global_id = json["global_id"],
        this.name = json["name"],
        this.label = json["label"],
        this.description = json["description"],
        this.condition_value = (json["condition_value"] ?? "")
            .replaceAll("FALSE", "false")
            .replaceAll("TRUE", "true")
            .replaceAll("False", "false")
            .replaceAll("True", "true"),
        this.dynamic_value = json["dynamic_value"],
        this.client_validation = json["client_validation"],
        this.dynamic_label = json["dynamic_label"],
        this.validation_message = json["validation_message"],
        this.smart_tbl_search = json["smart_tbl_search"],
        this.smart_tbl_search_col = json["smart_tbl_search_col"],
        this.created_date = json["created_date"],
        this.created_by = json["created_by"],
        this.modified_date = json["modified_date"],
        this.modified_by = json["modified_by"],
        this.widget_type = json["widget_type"],
        this.default_value = json["default_value"],
        this.attachment_link = json["attachment_link"],
        this.reference_id_1 = json["reference_id_1"],
        this.reference_id_2 = json["reference_id_2"],
        this.reference_id_3 = json["reference_id_3"],
        this.reference_id_4 = json["reference_id_4"],
        this.reference_id_5 = json["reference_id_5"],
        this.is_disabled = json["is_disabled"],
        this.is_readonly = json["is_readonly"],
        this.is_required = json["is_required"],
        this.is_action = json["is_action"],
        this.is_encrypt = json["is_encrypt"],
        this.is_hide_typing = json["is_hide_typing"],
        this.dynamic_attributes = json["dynamic_attributes"];

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "version": this.version,
        "data_type": this.data_type,
        "data_size": this.data_size,
        "sort_order": this.sort_order,
        "optionlist_id": this.optionlist_id,
        "low_value": this.low_value,
        "high_value": this.high_value,
        "keyboard_type": this.keyboard_type,
        "weighted_score": this.weighted_score,
        "global_id": this.global_id,
        "name": this.name,
        "label": this.label,
        "description": this.description,
        "condition_value": this.condition_value,
        "dynamic_value": this.dynamic_value,
        "client_validation": this.client_validation,
        "dynamic_label": this.dynamic_label,
        "validation_message": this.validation_message,
        "smart_tbl_search": this.smart_tbl_search,
        "smart_tbl_search_col": this.smart_tbl_search_col,
        "created_date": this.created_date,
        "created_by": this.created_by,
        "modified_date": this.modified_date,
        "modified_by": this.modified_by,
        "widget_type": this.widget_type,
        "default_value": this.default_value,
        "attachment_link": this.attachment_link,
        "reference_id_1": this.reference_id_1,
        "reference_id_2": this.reference_id_2,
        "reference_id_3": this.reference_id_3,
        "reference_id_4": this.reference_id_4,
        "reference_id_5": this.reference_id_5,
        "is_disabled": this.is_disabled,
        "is_readonly": this.is_readonly,
        "is_required": this.is_required,
        "is_action": this.is_action,
        "is_encrypt": this.is_encrypt,
        "is_hide_typing": this.is_hide_typing,
        "dynamic_attribute": this.dynamic_attributes
      };

  @override
  int get hashCode => id;

  @override
  String toString() {
    return json.encode(toJson());
  }
}
