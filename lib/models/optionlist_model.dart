class OptionListModel {
  final int id;
  final int version;
  final String global_id;
  final String name;
  final String created_date;
  final String created_by;
  final String modified_date;
  final String modified_by;
  final String option_icons;
  final bool shared;

  OptionListModel(
      this.id,
      this.version,
      this.global_id,
      this.name,
      this.created_date,
      this.created_by,
      this.modified_date,
      this.modified_by,
      this.option_icons,
      this.shared);

  OptionListModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        version = json["version"],
        global_id = json["global_id"],
        name = json["name"],
        created_date = json["created_date"],
        created_by = json["created_by"],
        modified_date = json["modified_date"],
        modified_by = json["modified_by"],
        option_icons = json["option_icons"],
        shared = json["shared"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "version": version,
        "global_id": global_id,
        "name": name,
        "created_date": created_date,
        "created_by": created_by,
        "modified_date": modified_date,
        "modified_by": modified_by,
        "option_icons": option_icons,
        "shared": shared
      };
}
