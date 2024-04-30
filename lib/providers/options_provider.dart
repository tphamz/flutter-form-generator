import 'package:sample/models/option_model.dart';

class OptionsProvider {
  List<OptionModel> options = [];
  OptionsProvider(Map<String, dynamic>? package, int? optionListId) : super() {
    if (optionListId != null &&
        package != null &&
        package.containsKey("assets_map") &&
        package["assets_map"].containsKey("option_list") &&
        package["assets_map"]["option_list"]
            .containsKey(optionListId.toString())) {
      options = List<OptionModel>.from(package["assets_map"]["option_list"]
              [optionListId.toString()]["options"]
          .map((option) => OptionModel.fromJson(option)));
    }
  }
}
