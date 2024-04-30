import 'package:flutter/services.dart';
import 'dart:convert';

Future<Map<String, dynamic>> getPackage(String name) async {
  String path = 'assets/$name.json';
  final res = await rootBundle.loadString(path);
  return jsonDecode(res);
}

List<String> getPackageNames() {
  return [
    'Package_waterfall',
    'package_zerion',
    'Package_Landis_Install_Form',
    'Package_simple_math',
    'Package_magnesium_package'
  ];
}
