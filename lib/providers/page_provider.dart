import 'package:sample/providers/package_provider.dart';

class PageProvider {
  PackageProvider packageProvider;
  Map<String, dynamic>? _page;
  String pageLevel = "";
  int pageIndex = 0;
  PageProvider({required this.packageProvider}) : super() {
    _page = null;
  }

  Map<String, dynamic>? get page {
    if (_page != null) return _page;
    List<Map<String, dynamic>> pages = [];
    var package = packageProvider.package;
    if (package == null) return null;
    package["assets_map"]["pages"].forEach((k, v) => pages.add(v));
    _page = pages.isNotEmpty ? pages[0] : {};
    return _page;
  }
}
