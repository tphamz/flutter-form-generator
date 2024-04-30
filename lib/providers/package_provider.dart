import 'package:sample/services/resource_service.dart';

class PackageProvider {
  Map<String, dynamic>? package;
  PackageProvider() : super() {
    package = null;
  }

  Future<Map<String, dynamic>?> setup(String name) async {
    try {
      package = await getPackage(name);
    } catch (e) {
      package = null;
    }
    return package;
  }
}
