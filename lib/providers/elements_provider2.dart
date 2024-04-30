import 'package:sample/providers/page_provider.dart';
import 'package:sample/models/element_model.dart';
import 'package:sample/providers/dependency_provider.dart';
import 'dart:core';
import 'dart:async';

class ElementsProvider extends DependencyProvider {
  PageProvider pageProvider;
  ElementsProvider({required this.pageProvider}) : super();
  Map<String, StreamController> senders = {};
  Map<String, Stream> receivers = {};
  List<ElementModel> get elements {
    Map<String, dynamic>? page = pageProvider.page;
    if (page == null || page["page_level"]["name"] == null) return [];
    if (!page.containsKey("elements")) return [];
    List elements = page["elements"]
        .where((i) => i["is_disabled"] == null || !i["is_disabled"])
        .toList();
    List<String> keywords = [];
    for (var ele in elements) {
      String elemName = ele["name"];
      keywords.add(elemName);
      senders[elemName] = StreamController();
      receivers[elemName] = senders[elemName]!.stream;
    }

    return List<ElementModel>.from(elements.map((element) {
      ElementModel elem = ElementModel.fromJson(element);
      findDependencies(page["page_level"]["name"], keywords, element);
      return elem;
    }));
  }
}
