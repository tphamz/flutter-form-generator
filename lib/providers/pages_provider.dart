import 'package:sample/services/resource_service.dart';
import 'package:sample/models/page_model.dart';

class PagesProvider {
  List<PageModel>? pages;
  PagesProvider() : super() {
    pages = [];
  }

  Future setup() async {
    pages = [];
    try {
      List<String> packages = getPackageNames();
      for (String packageName in packages) {
        var package = await getPackage(packageName);
        var packagePages = [];
        package["assets_map"]["pages"].forEach((k, v) => packagePages.add(v));
        var page = PageModel.fromJson(
            packagePages.isNotEmpty ? packagePages[0]["page_level"] : {});
        page.packageName = packageName;
        pages?.add(page);
      }
    } catch (e) {
      print(e);
    }
  }
}
