import 'package:theme_provider/theme_provider.dart';

class CustomThemeProvider {
  AppTheme? theme;
  CustomThemeProvider() {
    theme = null;
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
