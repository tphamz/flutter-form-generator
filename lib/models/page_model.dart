import 'dart:convert';

class PageModel {
  String? packageName;
  final int? id;
  final int? version;
  final int? sort_order;

  final String? global_id;
  final String? name;
  final String? label;
  final String? description;
  final String? created_date;
  final String? created_by;
  final String? modified_date;
  final String? modified_by;
  final String? icon;
  final String? page_javascript;
  final String? label_icons;
  final String? reference_id_1;
  final String? reference_id_2;
  final String? reference_id_3;
  final String? reference_id_4;
  final String? reference_id_5;

  final bool? is_disabled;
  final List<dynamic>? dynamic_attributes;
  final List<dynamic>? public_links;
  final List<dynamic>? localizations;

  final Map<String, dynamic> permissions;

  PageModel(
      this.id,
      this.version,
      this.sort_order,
      this.global_id,
      this.name,
      this.label,
      this.description,
      this.created_date,
      this.created_by,
      this.modified_date,
      this.modified_by,
      this.icon,
      this.page_javascript,
      this.label_icons,
      this.reference_id_1,
      this.reference_id_2,
      this.reference_id_3,
      this.reference_id_4,
      this.reference_id_5,
      this.is_disabled,
      this.dynamic_attributes,
      this.public_links,
      this.localizations,
      this.permissions);

  PageModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        version = json["version"],
        sort_order = json["sort_order"],
        global_id = json["global_id"],
        name = json["name"],
        label = json["label"],
        description = json["description"],
        created_date = json["created_date"],
        created_by = json["created_by"],
        modified_date = json["modified_date"],
        modified_by = json["modified_by"],
        icon = json["icon"],
        label_icons = json["label_icons"],
        page_javascript = json["page_javascript"],
        reference_id_1 = json["reference_id_1"],
        reference_id_2 = json["reference_id_2"],
        reference_id_3 = json["reference_id_3"],
        reference_id_4 = json["reference_id_4"],
        reference_id_5 = json["reference_id_5"],
        is_disabled = json["is_disabled"],
        dynamic_attributes = json["dynamic_attributes"],
        public_links = json["public_links"],
        localizations = json["localizations"],
        permissions = json["permissions"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "version": version,
        "sort_order": sort_order,
        "global_id": global_id,
        "name": name,
        "label": label,
        "description": description,
        "created_date": created_date,
        "created_by": created_by,
        "modified_date": modified_date,
        "modified_by": modified_by,
        "icon": icon,
        "label_icons": label_icons,
        "page_javascript": page_javascript,
        "reference_id_1": reference_id_1,
        "reference_id_2": reference_id_2,
        "reference_id_3": reference_id_3,
        "reference_id_4": reference_id_4,
        "reference_id_5": reference_id_5,
        "is_disabled": is_disabled,
        "dynamic_attribute": dynamic_attributes,
        "public_links": public_links,
        "localizations": localizations,
        "permissions": permissions
      };

  @override
  String toString() {
    return json.encode(toJson());
  }
}
